import math
from set2 import INK, svg, ug, sil, clip, inner, within, shadow, E, C, P, tear
def tufts(pts,col="#4f9e55"):
    return ''.join(f'<path d="M{x-6},{y} q2,-10 4,-14 M{x},{y} q0,-12 0,-17 M{x+6},{y} q-2,-10 -4,-14" stroke="{col}" stroke-width="3" fill="none" stroke-linecap="round"/>' for x,y in pts)
def rock(cx,cy,rx,ry):
    return sil([E(cx,cy,rx,ry)],"#a4a8ba",5)+f'<ellipse cx="{cx-rx*.3}" cy="{cy-ry*.35}" rx="{rx*.35}" ry="{ry*.25}" fill="#fff" opacity=".45"/>'

def river():
    patch=P("M20,150 C10,110 40,78 90,74 C130,70 170,66 206,80 C236,92 238,140 226,170 C214,198 170,206 120,204 C70,204 28,190 20,150 Z")
    water="M0,112 C40,98 80,124 120,112 C160,100 200,122 240,108 L240,160 C200,174 160,150 120,162 C80,174 40,150 0,164 Z"
    defs=ug("rg","#9be37f","#5cb457",70,205)+ug("rw","#8fd3ff","#3d8ee0",100,170)+clip("rp",[patch])
    s=sil([patch],"url(#rg)")
    s+=within("rp",f'<path d="{water}" fill="url(#rw)"/>'
        '<path d="M0,112 C40,98 80,124 120,112 C160,100 200,122 240,108" stroke="#4f9a55" stroke-width="5" fill="none"/>'
        '<path d="M240,160 C200,174 160,150 120,162 C80,174 40,150 0,164" stroke="#4f9a55" stroke-width="5" fill="none"/>'
        + ''.join(f'<path d="M{x},{y} q8,-5 16,0" stroke="#e6f6ff" stroke-width="3" fill="none" stroke-linecap="round"/>' for x,y in ((40,130),(84,142),(170,126),(196,144),(118,138),(60,150)))
        + '<ellipse cx="90" cy="84" rx="40" ry="6" fill="#fff" opacity=".25"/>')
    s+=sil([P("M150,136 m-14,0 a14,9 0 1,0 28,0 a14,9 0 1,0 -28,0 Z")],"#6cc46a",4)+'<path d="M150,136 L164,131" stroke="#3f8f50" stroke-width="2.5"/>'
    s+='<circle cx="146" cy="131" r="5" fill="#ff9bc0" stroke="%s" stroke-width="2"/><circle cx="146" cy="131" r="1.8" fill="#ffe27a"/>'%INK
    s+=rock(60,182,15,9)+rock(192,92,12,8)+rock(208,184,9,6)
    for x,h in ((40,46),(50,56),(30,38)):
        s+=f'<path d="M{x},104 L{x},{104-h}" stroke="{INK}" stroke-width="6" stroke-linecap="round"/><path d="M{x},104 L{x},{104-h}" stroke="#4f9a55" stroke-width="3" stroke-linecap="round"/>'
        s+=sil([E(x,104-h+8,4.5,10)],"#9a6a3c",4)
    s+=tufts(((100,198),(150,198),(30,170),(220,120)))
    return svg(shadow(124,98)+s,defs)

def berries():
    clumps=[C(78,134,40),C(120,104,46),C(162,134,40),C(98,162,40),C(146,162,40),E(122,174,72,34)]
    defs=ug("bg","#7fd06a","#3f9a4c",60,210)+clip("bc",clumps)
    s=sil([f'rect x="112" y="190" width="16" height="30" rx="5"'],"#9a6a3c",6)
    s+=sil(clumps,"url(#bg)")
    s+=within("bc",'<ellipse cx="122" cy="200" rx="80" ry="22" fill="#2f7a3e" opacity=".35"/>'
        + ''.join(f'<path d="M{x},{y} q6,-8 12,0 q-6,6 -12,0 Z" fill="#a6e88c" opacity=".7"/>' for x,y in ((70,112),(110,76),(150,112),(90,146),(132,140),(168,152),(104,118)))
        + '<ellipse cx="104" cy="80" rx="22" ry="8" fill="#fff" opacity=".25" transform="rotate(-20 104 80)"/>')
    for x,y in ((72,124),(96,100),(126,88),(152,110),(172,134),(108,138),(136,128),(86,160),(120,166),(156,162),(62,150)):
        s+=f'<circle cx="{x}" cy="{y}" r="9" fill="#e8394f" stroke="{INK}" stroke-width="2.5"/><circle cx="{x-3}" cy="{y-3}" r="2.8" fill="#fff" opacity=".85"/><path d="M{x},{y-9} l2,-4" stroke="#3f7a3c" stroke-width="2" stroke-linecap="round"/>'
    s+=tufts(((60,214),(180,214)))
    return svg(shadow(122,90)+s,defs)

def thorns():
    bush=[C(84,152,34),C(120,132,40),C(158,152,34),E(120,174,66,30)]
    defs=ug("tg","#5d9e68","#2c5a3c",90,210)+clip("tc",bush)
    branches=[("M100,150 Q70,120 36,94",),("M140,140 Q176,112 208,86",),("M120,124 Q114,90 120,50",),("M84,176 Q50,178 22,166",),("M158,176 Q192,180 220,170",)]
    s=''
    def thorn_along(d,n=4):
        nums=[float(v) for v in d.replace('M','').replace('Q',' ').replace(',',' ').split()]
        x0,y0,cx,cy,x1,y1=nums; out=''
        for k in range(1,n+1):
            t=k/(n+1)
            x=(1-t)**2*x0+2*(1-t)*t*cx+t*t*x1; y=(1-t)**2*y0+2*(1-t)*t*cy+t*t*y1
            dx=2*(1-t)*(cx-x0)+2*t*(x1-cx); dy=2*(1-t)*(cy-y0)+2*t*(y1-cy); L=math.hypot(dx,dy); nx,ny=-dy/L,dx/L
            sgn=1 if k%2 else -1
            bx,by=x+nx*3*sgn,y+ny*3*sgn; tx,ty=x+nx*15*sgn+dx/L*4,y+ny*15*sgn+dy/L*4
            out+=f'<path d="M{bx-dx/L*5},{by-dy/L*5} L{tx},{ty} L{bx+dx/L*5},{by+dy/L*5} Z" fill="#fff4dc" stroke="{INK}" stroke-width="2.2" stroke-linejoin="round"/>'
        return out
    for (d,) in branches:
        s+=f'<path d="{d}" stroke="{INK}" stroke-width="13" fill="none" stroke-linecap="round"/><path d="{d}" stroke="#8a5a34" stroke-width="7" fill="none" stroke-linecap="round"/>'
        s+=thorn_along(d)
    s+=sil(bush,"url(#tg)")
    for a in range(0,360,30):
        r=math.radians(a); cx,cy=120,156; rx,ry=70,48
        bx,by=cx+math.cos(r)*rx*.92,cy+math.sin(r)*ry*.92
        if by>196: continue
        tx,ty=cx+math.cos(r)*(rx+16),cy+math.sin(r)*(ry+16); px,py=-math.sin(r)*6,math.cos(r)*6
        s+=f'<path d="M{bx-px},{by-py} L{tx},{ty} L{bx+px},{by+py} Z" fill="#fff4dc" stroke="{INK}" stroke-width="2.2" stroke-linejoin="round"/>'
    s+=within("tc",'<ellipse cx="120" cy="198" rx="80" ry="20" fill="#1f4430" opacity=".35"/>'
        + ''.join(f'<path d="M{x},{y} l-5,-9 l10,0 Z" fill="#cfe8c8" opacity=".55"/>' for x,y in ((96,140),(126,124),(150,150),(110,166),(76,160),(140,174))))
    return svg(shadow(120,96)+s,defs)

def cave():
    mound=P("M14,214 C10,150 40,96 92,78 C122,68 160,72 186,92 C218,116 232,160 228,214 Z")
    arch="M76,214 C76,160 96,126 124,126 C152,126 172,160 172,214 Z"
    defs=ug("cg","#c4c7d6","#7d8198",70,214)+ug("cd","#2d2645","#100d1c",126,214)+clip("cm",[mound])+clip("ca",[P(arch)])
    s=sil([mound],"url(#cg)")
    s+=within("cm",'<path d="M40,104 C70,74 150,60 200,100 C170,86 120,84 92,92 C70,98 52,106 40,104 Z" fill="#78c46a"/>'
        '<path d="M40,104 C70,74 150,60 200,100" stroke="#4f9a55" stroke-width="3" fill="none"/>'
        + ''.join(f'<ellipse cx="{x}" cy="{y}" rx="{rx}" ry="{ry}" fill="#8e92a8" opacity=".55"/>' for x,y,rx,ry in ((44,160,14,9),(200,150,16,10),(60,196,10,6),(194,196,12,7),(150,106,12,6)))
        + f'<path d="M32,140 l12,8 l-4,12 M206,124 l-10,10 l6,10" stroke="{INK}" stroke-width="2" fill="none" opacity=".45" stroke-linecap="round"/>'
        + '<ellipse cx="90" cy="100" rx="30" ry="7" fill="#fff" opacity=".25" transform="rotate(-18 90 100)"/>')
    s+=f'<path d="{arch}" fill="none" stroke="#6c7088" stroke-width="14"/>'
    s+=f'<path d="{arch}" fill="url(#cd)" stroke="{INK}" stroke-width="4" stroke-linejoin="round"/>'
    s+=within("ca",'<ellipse cx="124" cy="214" rx="40" ry="14" fill="#3e3660" opacity=".8"/><path d="M90,170 C92,148 104,136 118,134" stroke="#5a5378" stroke-width="5" fill="none" stroke-linecap="round" opacity=".7"/>')
    s+=rock(60,214,10,6)+rock(186,212,8,5)+tufts(((30,214),(214,214),(70,212)))
    return svg(shadow(120,108)+s,defs)

def shy_dino():
    L1,L0,LD="#d7cbff","#a993ea","#7f69c4"; CREAM="#f6efff"
    B=("M8,112 C20,128 52,140 86,128 C100,118 124,104 146,110 "
       "C156,98 170,82 188,82 "
       "C206,82 222,92 228,110 C234,124 228,138 216,140 C208,141 202,138 198,132 "
       "C190,124 178,124 172,134 "
       "C168,140 166,146 164,152 "
       "C162,170 160,186 161,196 C162,202 164,206 164,212 C164,217 161,218 156,218 L146,218 C141,218 140,216 140,212 "
       "C140,206 142,200 142,192 C142,186 140,183 136,181 C126,186 110,186 100,181 "
       "C97,186 96,194 96,200 C96,206 98,208 98,212 C98,217 95,218 90,218 L80,218 C75,218 74,216 74,212 "
       "C74,206 77,198 76,190 C75,180 70,170 70,162 C58,154 22,140 8,112 Z")
    defs=ug("sg",L1,L0,70,220)+ug("sfl",L0,LD,170,220)+clip("sc",[P(B)])
    def far(x0,x1):
        d=f"M{x0},172 L{x1},172 L{x1},212 C{x1},217 {x1-3},218 {x1-8},218 L{x0+8},218 C{x0+3},218 {x0},217 {x0},212 Z"
        return sil([P(d)],"url(#sfl)")
    nails=lambda xs:''.join(f'<ellipse cx="{x}" cy="213" rx="2.6" ry="3.3" fill="#fff" stroke="{INK}" stroke-width="1.5"/>' for x in xs)
    s=far(86,108)+far(126,148)+nails((104,))+nails((133,))+sil([P(B)],"url(#sg)")
    s+=within("sc",'<ellipse cx="116" cy="114" rx="28" ry="5" fill="#fff" opacity=".3" transform="rotate(-8 116 114)"/>'
        f'<path d="M100,181 C94,168 84,162 72,162" stroke="{LD}" stroke-width="2.4" fill="none" opacity=".55" stroke-linecap="round"/>'
        f'<path d="M136,181 C140,168 150,160 162,156" stroke="{LD}" stroke-width="2.4" fill="none" opacity=".55" stroke-linecap="round"/>'
        f'<path d="M98,181 C110,186 126,186 138,181 C130,176 122,175 118,175 C114,175 106,176 98,181 Z" fill="{CREAM}" opacity=".85"/>'
        + ''.join(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{LD}" opacity=".45"/>' for x,y,r in ((100,124,5),(120,116,5.5),(138,120,4),(56,136,3),(36,134,2.4)))
        + '<ellipse cx="200" cy="90" rx="9" ry="3.5" fill="#fff" opacity=".4" transform="rotate(15 200 90)"/>')
    s+=nails((80,86,92))+nails((146,152,158))
    # shy face: eye looking down under a heavy lid, big blush, tiny wobbly mouth, sweat drop
    s+=f'<ellipse cx="208" cy="108" rx="6.5" ry="7.5" fill="#fff" stroke="{INK}" stroke-width="2"/><ellipse cx="208" cy="111.5" rx="3.6" ry="4" fill="{INK}"/><circle cx="209.5" cy="110" r="1.2" fill="#fff"/>'
    s+=f'<path d="M200.5,106 Q208,100 215.5,106 L215.5,101 L200.5,101 Z" fill="url(#sg)"/><path d="M200,106.5 Q208,101 216,106.5" stroke="{INK}" stroke-width="2.4" fill="none" stroke-linecap="round"/>'
    s+='<ellipse cx="212" cy="123" rx="8" ry="4.5" fill="#ff8fa3" opacity=".9"/>'+''.join(f'<path d="M{207+i*4},120.5 l-1.5,5" stroke="#ff6f8a" stroke-width="1.6" stroke-linecap="round"/>' for i in range(3))
    s+=f'<path d="M218,133 q2,-2 4,0 q2,2 4,0" stroke="{INK}" stroke-width="2" fill="none" stroke-linecap="round"/>'
    s+=tear(186,62,.8)
    return svg(shadow(114,80)+s,defs)

def group():
    def mini(cx,cy,col,lt,gid,s_=1.0):
        body=E(cx,cy,30*s_,30*s_); head=E(cx,cy-34*s_,27*s_,24*s_)
        arms=[E(cx-30*s_,cy-14*s_,7*s_,14*s_,30),E(cx+30*s_,cy-14*s_,7*s_,14*s_,-30)]
        feet=[E(cx-14*s_,cy+28*s_,11*s_,6*s_),E(cx+14*s_,cy+28*s_,11*s_,6*s_)]
        tail=P(f"M{cx+20*s_},{cy+10*s_} C{cx+40*s_},{cy+14*s_} {cx+48*s_},{cy+2*s_} {cx+50*s_},{cy-10*s_} C{cx+40*s_},{cy-2*s_} {cx+32*s_},{cy-2*s_} {cx+22*s_},{cy-4*s_} Z")
        spikes=''.join(sil([P(f"M{cx+dx*s_-6*s_},{cy-52*s_+abs(dx)*.25*s_} L{cx+dx*s_},{cy-66*s_+abs(dx)*.35*s_} L{cx+dx*s_+6*s_},{cy-52*s_+abs(dx)*.25*s_} Z")],"#ffd166",4) for dx in (-12,0,12))
        defs=ug(gid,lt,col,cy-60*s_,cy+34*s_)+clip(gid+"b",[body])
        parts=[tail]+feet+arms+[body,head]
        g=spikes+sil(parts,f"url(#{gid})")
        g+=within(gid+"b",f'<ellipse cx="{cx}" cy="{cy+8*s_}" rx="{18*s_}" ry="{18*s_}" fill="#fff6e0" opacity=".9"/>')
        g+=inner(head,gid+"b")+''.join(inner(a,gid+"b") for a in arms)+''.join(inner(f,gid+"b") for f in feet)
        for ex in (-10,10):
            g+=f'<ellipse cx="{cx+ex*s_}" cy="{cy-38*s_}" rx="{5*s_}" ry="{6.5*s_}" fill="{INK}"/><circle cx="{cx+ex*s_+1.8*s_}" cy="{cy-40.5*s_}" r="{2*s_}" fill="#fff"/>'
        g+=f'<ellipse cx="{cx-17*s_}" cy="{cy-28*s_}" rx="{5*s_}" ry="{3*s_}" fill="#ff8fa3" opacity=".8"/><ellipse cx="{cx+17*s_}" cy="{cy-28*s_}" rx="{5*s_}" ry="{3*s_}" fill="#ff8fa3" opacity=".8"/>'
        g+=f'<path d="M{cx-8*s_},{cy-27*s_} Q{cx},{cy-16*s_} {cx+8*s_},{cy-27*s_} Z" fill="#7a2d3d" stroke="{INK}" stroke-width="{2*s_}" stroke-linejoin="round"/>'
        return defs,g
    d1,g1=mini(62,166,"#f2c94c","#ffe58f","ga")
    d2,g2=mini(178,166,"#f28fb3","#ffc2d6","gb")
    d3,g3=mini(120,182,"#6fb3f2","#b5dbff","gc",.92)
    ball=sil([C(120,62,20)],"#ef4a5a",5)+f'<path d="M102,56 Q120,70 138,56" stroke="#fff" stroke-width="5" fill="none"/><path d="M106,48 Q120,42 134,48" stroke="#fff" stroke-width="3" fill="none" opacity=".8"/><circle cx="112" cy="53" r="3.5" fill="#fff" opacity=".8"/>'
    motion=''.join(f'<path d="{d}" stroke="#b8a77f" stroke-width="3" fill="none" stroke-linecap="round"/>' for d in ("M88,40 q-6,8 -4,18","M152,40 q6,8 4,18","M96,28 q-4,4 -4,10"))
    return svg(shadow(120,104)+motion+g1+g2+g3+ball,d1+d2+d3)

def grass_patch():
    base=P("M24,206 C20,190 40,182 70,184 C110,178 150,180 186,182 C214,184 222,196 216,208 C200,218 60,218 24,206 Z")
    defs=ug("gp","#9be37f","#4aa650",120,215)
    s=sil([base],"#5cb457",6)
    blades=""
    for i,(x,h,lean) in enumerate(((40,70,-10),(58,96,6),(76,80,-4),(94,112,8),(112,90,-6),(130,118,4),(148,94,-8),(166,104,6),(184,78,-4),(200,62,8),(68,60,10),(122,66,-10),(176,58,4))):
        tip_x=x+lean; tip_y=200-h
        blades+=sil([P(f"M{x-7},202 C{x-6},{200-h*.5} {tip_x-2},{tip_y+10} {tip_x},{tip_y} C{tip_x+3},{tip_y+12} {x+6},{200-h*.45} {x+7},202 Z")],"url(#gp)",5)
    s+=blades
    for x,h in ((58,96),(94,112),(130,118),(166,104)):
        s+=f'<path d="M{x},196 L{x+2},{206-h}" stroke="#c4f2a8" stroke-width="2" opacity=".6" stroke-linecap="round"/>'
    s+=''.join(f'<circle cx="{x}" cy="{y}" r="5" fill="#ffd166" stroke="{INK}" stroke-width="2"/>' for x,y in ((84,150),(156,140)))
    return svg(shadow(120,96)+s,defs)

def hill_big():
    hill=P("M10,214 C30,150 70,92 120,88 C170,84 210,150 230,214 Z")
    defs=ug("hl","#9be37f","#4f9e55",80,214)+clip("hc",[hill])
    s=sil([hill],"url(#hl)")
    s+=within("hc",'<path d="M10,170 C60,150 110,176 160,156 C190,146 220,160 240,156 L240,240 L0,240 Z" fill="#3f8f50" opacity=".25"/>'
        '<ellipse cx="98" cy="104" rx="30" ry="8" fill="#fff" opacity=".3" transform="rotate(-18 98 104)"/>'
        '<path d="M120,214 C116,180 128,150 122,116" stroke="#d9b77a" stroke-width="10" fill="none" stroke-linecap="round"/>')
    s+=sil([P("M122,88 L122,52")],"none",6)+'<path d="M122,88 L122,52" stroke="#8a5a33" stroke-width="4"/>'
    s+=sil([P("M124,52 L150,60 L124,70 Z")],"#ef4a5a",4)
    s+=tufts(((50,200),(190,200),(80,150),(160,140)))
    return svg(shadow(120,110)+s,defs)

OBJ=[("River",river),("Berry bush",berries),("Thorns",thorns),("Cave",cave),("Shy dino",shy_dino),("Group playing",group),("Grass",grass_patch),("Hill",hill_big)]
if __name__=="__main__":
    cards=''.join(f'<div class="c">{f()}<div class="n">{n}</div></div>' for n,f in OBJ)
    open("objs2.html","w").write(f'<html><body style="margin:0;background:#3c4060;font-family:Arial,sans-serif"><div style="padding:22px 26px;color:#fff;font-size:26px">OBJECTS (smooth style)</div><div style="display:grid;grid-template-columns:repeat(3,420px);gap:22px;padding:0 26px 26px">{cards}</div><style>.c{{background:#f1ead8;border-radius:14px;padding:10px 10px 12px;text-align:center}}.c svg{{width:100%;display:block}}.n{{font-size:22px;color:#1e2236;font-weight:bold}}</style></body></html>')
