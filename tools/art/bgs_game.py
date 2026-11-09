# Game-layout backgrounds: the ground starts high (about 40% down), because in the
# game the objects stand in a back row (feet at ~40% of the screen) and the
# player walks lower down (~78%). Uses the helpers from bgs2.py.
from bgs2 import svg, lg, rg, rect, path, cloud, flower, grass, tree, rock

def meadow():
    d=lg("sky",[(0,"#79c8ff"),(1,"#d6f1ff")],0,80)+lg("g",[(0,"#8fdc78"),(1,"#5cb457")],70,200)
    s=rect("url(#sky)")+'<circle cx="236" cy="36" r="12" fill="#ffe27a"/><circle cx="236" cy="36" r="18" fill="#ffe27a" opacity=".3"/>'
    s+=cloud(84,38,.7)+cloud(170,32,.55)
    s+=path("M0,70 C50,52 100,56 150,66 C200,76 260,52 320,62 L320,90 L0,90 Z","#a6e08f")
    s+=path("M0,82 C80,74 160,80 240,78 C280,77 300,80 320,80 L320,200 L0,200 Z","url(#g)")
    s+=path("M0,140 C80,130 200,150 320,136 L320,200 L0,200 Z","#56ad54",op=.5)
    for x,y,c in ((70,100,"#ff8fb1"),(130,96,"#fff"),(200,104,"#ffd166"),(250,98,"#ff8fb1"),(20,120,"#ffd166"),(300,124,"#fff"),(100,182,"#ff8fb1"),(230,186,"#ffd166"),(40,178,"#fff"),(280,180,"#ff8fb1")):
        s+=flower(x,y,c,.8)
    s+=''.join(grass(x,y) for x,y in ((50,110),(170,108),(270,112),(110,190),(200,192),(300,190),(10,150)))
    return svg(s,d)

def forest():
    d=lg("bg",[(0,"#c4ecaa"),(1,"#86c477")],0,90)+lg("fl",[(0,"#6ab865"),(1,"#4a9a50")],80,200)
    s=rect("url(#bg)")
    for x in (80,160,240): s+=f'<path d="M{x},0 L{x+24},0 L{x-6},90 L{x-36},90 Z" fill="#fffbd0" opacity=".25"/>'
    for x in (30,85,140,195,250,305):
        s+=f'<rect x="{x-3}" y="30" width="6" height="56" fill="#6a8a58" opacity=".55"/><ellipse cx="{x}" cy="32" rx="22" ry="24" fill="#78b863" opacity=".6"/>'
    for x,w in ((10,16),(312,18)):
        s+=f'<rect x="{x-w/2}" y="0" width="{w}" height="92" fill="#8a5a33"/><rect x="{x-w/2}" y="0" width="{w*.3}" height="92" fill="#a7774a"/>'
    s+=path("M-10,0 L330,0 L330,20 C280,32 250,14 214,28 C180,40 150,18 110,30 C70,40 40,22 -10,30 Z","#3f9a4c")
    s+=path("M-10,0 L330,0 L330,10 C270,20 230,6 190,16 C150,26 110,8 70,18 C40,24 20,14 -10,20 Z","#2f7a3e")
    s+=path("M0,84 C80,78 160,86 240,80 C280,78 300,82 320,82 L320,200 L0,200 Z","url(#fl)")
    s+=path("M120,200 C140,160 156,120 160,86 C166,120 182,160 204,200 Z","#d9b77a",op=.85)
    for x,y in ((30,170),(296,176)):
        s+=f'<ellipse cx="{x}" cy="{y}" rx="24" ry="11" fill="#4aa650"/><ellipse cx="{x-6}" cy="{y-4}" rx="10" ry="4" fill="#7fd06a" opacity=".7"/>'
    for x,y,k in ((250,186,1),(262,190,.7),(52,184,.8)):
        s+=f'<rect x="{x-3*k}" y="{y-9*k}" width="{6*k}" height="{10*k}" rx="2" fill="#fff3dc"/><path d="M{x-11*k},{y-8*k} Q{x},{y-26*k} {x+11*k},{y-8*k} Z" fill="#ef4a5a"/><circle cx="{x-3*k}" cy="{y-15*k}" r="{1.8*k}" fill="#fff"/>'
    s+=''.join(grass(x,y,"#3d7f46") for x,y in ((20,140),(90,120),(230,124),(300,150),(80,192)))
    s+=''.join(flower(x,y,c,.8) for x,y,c in ((210,190,"#ffd166"),(100,170,"#fff"),(290,120,"#ff8fb1")))
    return svg(s,d)

def hilltop():
    d=lg("sky",[(0,"#5a5fb8"),(.5,"#ee7fa0"),(1,"#ffc27a")],0,84)+rg("sun",200,70,40,[(0,"#fff2a8",1),(1,"#ffb86b",0)])+lg("g",[(0,"#6fb36a"),(1,"#3f8a4c")],76,200)
    s=rect("url(#sky)")
    for x,y in ((30,10),(90,24),(150,8),(230,18),(300,10),(270,30)): s+=f'<circle cx="{x}" cy="{y}" r="1.2" fill="#fff" opacity=".85"/>'
    s+='<circle cx="200" cy="70" r="40" fill="url(#sun)"/><circle cx="200" cy="70" r="15" fill="#fff0a0"/>'
    s+=cloud(70,36,.8,"#ffd0dc",.9)+cloud(280,30,.7,"#ffe0d0",.9)
    s+=path("M0,70 C40,58 80,62 120,68 C170,76 210,64 250,70 C280,74 300,66 320,68 L320,100 L0,100 Z","#5a4a8a")
    s+=path("M0,84 C80,74 160,80 240,78 C280,77 300,82 320,80 L320,200 L0,200 Z","url(#g)")
    s+=path("M0,84 C80,74 160,80 240,78 C280,77 300,82 320,80","none","#a6e88c",2.5,.6)
    s+=''.join(grass(x,y,"#9ad888") for x,y in ((40,110),(110,100),(220,106),(290,120),(60,180),(250,190)))
    s+=''.join(flower(x,y,c,.8) for x,y,c in ((80,124,"#ffd0dc"),(170,112,"#ffe27a"),(260,130,"#fff"),(30,186,"#ffd0dc"),(300,184,"#ffe27a")))
    return svg(s,d)

def cave_inside():
    d=lg("w",[(0,"#4a4478"),(1,"#2e2a52")],0,90)+lg("fl",[(0,"#5a5384"),(1,"#3b3566")],80,200)+rg("g1",60,90,50,[(0,"#8fe7ff",.7),(1,"#8fe7ff",0)])+rg("g2",262,88,48,[(0,"#ff9be0",.6),(1,"#ff9be0",0)])
    s=rect("url(#w)")
    s+=path("M0,0 L320,0 L320,16 C290,28 270,14 246,26 C220,36 200,18 170,24 C140,32 120,16 90,26 C60,34 40,20 0,28 Z","#3b3566")
    for x,h in ((30,30),(80,40),(140,28),(200,38),(260,30),(300,40)):
        s+=f'<path d="M{x-9},10 C{x-6},{h*.6} {x-2},{h-3} {x},{h+4} C{x+2},{h-3} {x+6},{h*.6} {x+9},10 Z" fill="#5a5384"/>'
    s+=path("M0,84 C80,78 160,86 240,80 C280,78 300,82 320,82 L320,200 L0,200 Z","url(#fl)")
    s+='<circle cx="60" cy="90" r="50" fill="url(#g1)"/><circle cx="262" cy="88" r="48" fill="url(#g2)"/>'
    def cry(x,y,h,c,l): return f'<path d="M{x-6},{y} L{x-4},{y-h*.7} L{x},{y-h} L{x+4},{y-h*.7} L{x+6},{y} Z" fill="{c}"/><path d="M{x-2},{y} L{x-1},{y-h*.7} L{x},{y-h} L{x+1},{y} Z" fill="{l}" opacity=".7"/>'
    s+=cry(14,92,22,"#5fd3f2","#d6f7ff")+cry(26,94,30,"#5fd3f2","#d6f7ff")+cry(304,92,28,"#f27fd0","#ffd6f3")+cry(292,94,18,"#ff9be0","#ffe8f8")
    s+=rock(40,180,20,9,"#7a74a8")+rock(290,184,16,8,"#7a74a8")+rock(160,120,12,5,"#6a6498")
    for x,y in ((60,50),(150,56),(210,46),(280,60)): s+=f'<circle cx="{x}" cy="{y}" r="1.4" fill="#ffe27a" opacity=".8"/>'
    return svg(s,d)

def room():
    d=lg("wall",[(0,"#ffe9c9"),(1,"#ffd7a8")],0,84)+lg("fl",[(0,"#c98f5a"),(1,"#a87444")],84,200)+lg("win",[(0,"#79c8ff"),(1,"#d6f1ff")],10,50)
    s=rect("url(#wall)")
    for x in range(10,320,30): s+=f'<path d="M{x},0 L{x},84" stroke="#ffcf9a" stroke-width="2" opacity=".5"/>'
    s+=rect("url(#fl)",0,84,320,116)+'<path d="M0,84 L320,84" stroke="#8a5a33" stroke-width="3"/>'
    for x in range(-40,360,40): s+=f'<path d="M{x},86 L{x+(x-160)*.5},200" stroke="#8a5a33" stroke-width="1.5" opacity=".4"/>'
    s+='<rect x="130" y="24" width="60" height="40" rx="5" fill="#fff3dc"/><rect x="135" y="29" width="50" height="30" rx="3" fill="url(#win)"/>'
    s+=cloud(150,42,.4)+'<circle cx="174" cy="38" r="5" fill="#ffe27a"/><path d="M160,29 L160,59 M135,44 L185,44" stroke="#fff3dc" stroke-width="3"/>'
    s+=path("M124,22 C130,40 128,54 124,66 L134,66 C131,54 132,40 138,22 Z","#ff8fa3")+path("M196,22 C190,40 192,54 196,66 L186,66 C189,54 188,40 182,22 Z","#ff8fa3")
    s+='<rect x="60" y="30" width="34" height="24" rx="2" fill="#a87444"/><rect x="63" y="33" width="28" height="18" fill="#9be37f"/><circle cx="72" cy="42" r="4" fill="#ffd166"/>'
    s+='<rect x="226" y="30" width="26" height="26" rx="13" fill="#fff3dc" stroke="#a87444" stroke-width="2"/><path d="M239,43 L239,35 M239,43 L245,43" stroke="#1e2236" stroke-width="2" stroke-linecap="round"/>'
    s+='<ellipse cx="160" cy="150" rx="110" ry="26" fill="#ef7a8a"/><ellipse cx="160" cy="150" rx="90" ry="19" fill="#ffc2c8"/><ellipse cx="160" cy="150" rx="60" ry="11" fill="#ef7a8a"/>'
    return svg(s,d)

BG=[("Sunny meadow",meadow),("Forest",forest),("Hilltop sunset",hilltop),("Cave inside",cave_inside),("Cozy room",room)]
if __name__=="__main__":
    import bgs2
    cards=''.join(f'<div class="c">{f()}<div class="n">{n}</div></div>' for n,f in BG)
    open("bgs_game.html","w").write(f'<html><body style="margin:0;background:#3c4060;font-family:Arial,sans-serif"><div style="display:grid;grid-template-columns:repeat(2,640px);gap:22px;padding:26px">{cards}</div><style>.c{{background:#f1ead8;border-radius:14px;padding:10px;text-align:center}}.c svg{{width:100%;display:block}}.n{{font-size:22px;font-weight:bold}}</style></body></html>')
