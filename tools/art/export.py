import re, os, set2, objs2, bgs2, bgs_game
from playwright.sync_api import sync_playwright
from PIL import Image
OUT=os.path.join(os.path.dirname(os.path.abspath(__file__)),"..","..","datafiles"); os.makedirs(OUT,exist_ok=True)
noshadow=lambda s: re.sub(r'<ellipse cx="[^"]*" cy="226" rx="[^"]*" ry="7" fill="#000" opacity=".13"/>','',s)
bgs2.frame=lambda b:b
jobs=[]
cmap={"dot":"dino","panda":"panda","kiko":"kiko","buzz":"buzz","pip":"pip","bun":"bun"}
for n,e,f in set2.SET: jobs.append(("art_char_"+cmap[f.__name__], noshadow(f()), 600, 600, True))
omap={"river":"river","berries":"bush","thorns":"thorns","cave":"cave","shy_dino":"shy","group":"group","grass_patch":"grass","hill_big":"hill"}
for n,f in objs2.OBJ: jobs.append(("art_obj_"+omap[f.__name__], noshadow(f()), 600, 600, True))
bmap={"meadow":"meadow","forest":"forest","hilltop":"hilltop","cave_inside":"cave_inside","room":"room"}
for n,f in bgs_game.BG: jobs.append(("art_bg_"+bmap[f.__name__], f().replace('rx="10"/></clipPath>','/></clipPath>'), 1280, 800, False))
with sync_playwright() as p:
    b=p.chromium.launch()
    for name,svg,w,h,trim in jobs:
        pg=b.new_page(viewport={'width':w,'height':h})
        pg.set_content(f'<html><body style="margin:0;background:transparent">{svg.replace("<svg ",f"<svg width=\"{w}\" height=\"{h}\" ",1)}</body></html>')
        path=f"{OUT}/{name}.png"; pg.screenshot(path=path,omit_background=True,clip={'x':0,'y':0,'width':w,'height':h}); pg.close()
        if trim:
            im=Image.open(path); bb=im.getbbox(); im=im.crop((bb[0]-4,bb[1]-4,bb[2]+4,bb[3]+4)); im.save(path)
        print(name, Image.open(path).size)
    b.close()
