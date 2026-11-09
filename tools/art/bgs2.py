import math
INK="#1e2236"
import re
_n=[0]
def svg(body,defs=""):
    _n[0]+=1; p=f"s{_n[0]}_"
    defs+='<clipPath id="rc"><rect width="320" height="200" rx="10"/></clipPath>'
    out=f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 200"><defs>{defs}</defs><g clip-path="url(#rc)">{body}</g></svg>'
    out=re.sub(r'id="([^"]+)"',lambda m:f'id="{p}{m.group(1)}"',out)
    return re.sub(r'url\(#([^)]+)\)',lambda m:f'url(#{p}{m.group(1)})',out)
def lg(i,stops,y1=0,y2=200):
    st=''.join(f'<stop offset="{o}" stop-color="{c}"/>' for o,c in stops)
    return f'<linearGradient id="{i}" gradientUnits="userSpaceOnUse" x1="0" y1="{y1}" x2="0" y2="{y2}">{st}</linearGradient>'
def rg(i,cx,cy,r,stops):
    st=''.join(f'<stop offset="{o}" stop-color="{c}" stop-opacity="{a}"/>' for o,c,a in stops)
    return f'<radialGradient id="{i}" gradientUnits="userSpaceOnUse" cx="{cx}" cy="{cy}" r="{r}">{st}</radialGradient>'
def rect(fill,x=0,y=0,w=320,h=200): return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{fill}"/>'
def path(d,fill,stroke=None,sw=3,op=1):
    s=f' stroke="{stroke}" stroke-width="{sw}" stroke-linejoin="round" stroke-linecap="round"' if stroke else ''
    return f'<path d="{d}" fill="{fill}"{s} opacity="{op}"/>'
def cloud(x,y,s=1,col="#fff",op=1):
    return (f'<g opacity="{op}" fill="{col}"><ellipse cx="{x}" cy="{y}" rx="{26*s}" ry="{10*s}"/>'
            f'<ellipse cx="{x-14*s}" cy="{y-5*s}" rx="{15*s}" ry="{11*s}"/><ellipse cx="{x+8*s}" cy="{y-9*s}" rx="{17*s}" ry="{13*s}"/></g>')
def flower(x,y,col="#ff8fb1",s=1):
    pet=''.join(f'<circle cx="{x+math.cos(a)*3.6*s:.1f}" cy="{y-8*s+math.sin(a)*3.6*s:.1f}" r="{2.8*s}" fill="{col}"/>' for a in [i*math.pi*2/5 for i in range(5)])
    return f'<path d="M{x},{y} L{x},{y-8*s}" stroke="#3f8f50" stroke-width="{1.8*s}" stroke-linecap="round"/>'+pet+f'<circle cx="{x}" cy="{y-8*s}" r="{1.8*s}" fill="#ffe27a"/>'
def grass(x,y,col="#4f9e55",s=1):
    return f'<path d="M{x-4*s},{y} q1,-7 3,-10 M{x},{y} q0,-9 0,-13 M{x+4*s},{y} q-1,-7 -3,-10" stroke="{col}" stroke-width="2.2" fill="none" stroke-linecap="round"/>'
def tree(x,y,s=1,col="#4aa650",lt="#7fd06a"):
    return (f'<rect x="{x-4*s}" y="{y-26*s}" width="{8*s}" height="{28*s}" rx="3" fill="#8a5a33"/>'
            f'<circle cx="{x}" cy="{y-40*s}" r="{22*s}" fill="{col}"/><circle cx="{x-14*s}" cy="{y-30*s}" r="{15*s}" fill="{col}"/><circle cx="{x+14*s}" cy="{y-30*s}" r="{15*s}" fill="{col}"/>'
            f'<ellipse cx="{x-7*s}" cy="{y-48*s}" rx="{9*s}" ry="{5*s}" fill="{lt}" opacity=".7"/>')
def rock(x,y,rx,ry,col="#a4a8ba"):
    return f'<ellipse cx="{x}" cy="{y}" rx="{rx}" ry="{ry}" fill="{col}"/><ellipse cx="{x-rx*.3}" cy="{y-ry*.35}" rx="{rx*.35}" ry="{ry*.25}" fill="#fff" opacity=".4"/>'
def frame(body): return body+f'<rect x="1.5" y="1.5" width="317" height="197" rx="10" fill="none" stroke="{INK}" stroke-width="3"/>'

def meadow():
    d=lg("sky",[(0,"#79c8ff"),(1,"#d6f1ff")],0,130)+lg("h1",[(0,"#8fdc78"),(1,"#5cb457")],90,200)+lg("h2",[(0,"#6fc666"),(1,"#4aa650")],110,200)
    s=rect("url(#sky)")
    s+='<circle cx="258" cy="38" r="22" fill="#ffe27a"/><circle cx="258" cy="38" r="30" fill="#ffe27a" opacity=".3"/>'
    s+=cloud(70,40,1.2)+cloud(170,26,.9)+cloud(120,62,.8,op=.9)
    s+=path("M0,120 C50,92 100,96 150,114 C200,130 260,92 320,108 L320,200 L0,200 Z","#8ed77f")
    s+=tree(238,128,.8)
    s+=path("M0,150 C60,126 130,132 190,148 C240,160 290,140 320,146 L320,200 L0,200 Z","url(#h1)")
    s+=path("M0,178 C70,160 150,168 220,176 C270,182 300,172 320,170 L320,200 L0,200 Z","url(#h2)")
    for x,y,c in ((40,176,"#ff8fb1"),(70,186,"#fff"),(110,170,"#ffd166"),(150,184,"#ff8fb1"),(210,180,"#fff"),(250,172,"#ffd166"),(290,184,"#ff8fb1"),(185,164,"#ff8fb1"),(20,192,"#ffd166")):
        s+=flower(x,y,c,.9)
    s+=''.join(grass(x,y) for x,y in ((90,194),(130,176),(235,192),(270,176),(55,168)))
    return svg(frame(s),d)

def riverbank():
    d=lg("sky",[(0,"#8ad0ff"),(1,"#e4f6ff")],0,110)+lg("wt",[(0,"#79c4f5"),(1,"#3d8ee0")],100,170)+lg("gr",[(0,"#7fd06a"),(1,"#4aa650")],150,200)
    s=rect("url(#sky)")+cloud(60,32,1)+cloud(230,44,1.1,op=.95)
    s+=path("M0,92 C40,64 90,66 130,86 C170,100 220,70 320,88 L320,120 L0,120 Z","#9ad98a")
    s+=path("M0,98 C60,84 120,100 180,92 C240,84 280,96 320,92 L320,110 L0,110 Z","#6fc666")
    s+=path("M0,100 L320,100 L320,172 C260,162 200,176 150,168 C90,160 50,176 0,168 Z","url(#wt)")
    for x,y in ((30,122),(100,136),(170,118),(230,140),(280,124),(60,150),(200,156),(130,152)):
        s+=f'<path d="M{x},{y} q9,-5 18,0" stroke="#e6f6ff" stroke-width="2.6" fill="none" stroke-linecap="round"/>'
    s+=f'<path d="M0,100 C80,96 220,104 320,100" stroke="#4f9a55" stroke-width="3" fill="none"/>'
    s+=path("M0,168 C50,176 90,160 150,168 C200,176 260,162 320,172 L320,200 L0,200 Z","url(#gr)")
    s+=f'<path d="M0,168 C50,176 90,160 150,168 C200,176 260,162 320,172" stroke="#3f8f50" stroke-width="3" fill="none"/>'
    s+=rock(52,188,16,8)+rock(262,190,12,6)+rock(160,128,10,6,"#b3b7c9")
    s+=''.join(grass(x,y) for x,y in ((100,190),(140,184),(205,190),(300,186),(20,184)))
    s+=''.join(flower(x,y,c,.8) for x,y,c in ((90,184,"#ffd166"),(220,186,"#ff8fb1"),(285,194,"#fff")))
    # cattails
    for x,h in ((24,34),(34,42),(14,28)):
        s+=f'<path d="M{x},176 L{x},{176-h}" stroke="#4f9a55" stroke-width="2.6" stroke-linecap="round"/><ellipse cx="{x}" cy="{176-h+6}" rx="3.4" ry="8" fill="#9a6a3c"/>'
    s+=f'<ellipse cx="205" cy="146" rx="13" ry="5" fill="#6cc46a"/><circle cx="202" cy="143" r="3.5" fill="#ff9bc0"/>'
    return svg(frame(s),d)

def forest():
    d=lg("bg",[(0,"#b9e6a0"),(1,"#6fb86a")],0,200)+lg("fl",[(0,"#5aa557"),(1,"#3d7f46")],140,200)
    s=rect("url(#bg)")
    # light rays
    for x in (80,150,220):
        s+=f'<path d="M{x},0 L{x+30},0 L{x-20},170 L{x-60},170 Z" fill="#fffbd0" opacity=".22"/>'
    # far trees
    for x in (20,70,125,175,240,295):
        s+=f'<rect x="{x-4}" y="60" width="8" height="90" fill="#6a8a58" opacity=".6"/><ellipse cx="{x}" cy="62" rx="26" ry="30" fill="#78b863" opacity=".6"/>'
    # near trunks
    for x,w in ((36,22),(278,26)):
        s+=f'<rect x="{x-w/2}" y="0" width="{w}" height="170" fill="#8a5a33"/><rect x="{x-w/2}" y="0" width="{w*.3}" height="170" fill="#a7774a"/>'
        s+=f'<path d="M{x-w/2-8},170 q8,-10 8,-24 M{x+w/2+8},170 q-8,-10 -8,-24" stroke="#8a5a33" stroke-width="6" fill="none"/>'
    s+=path("M-10,0 L320,0 L320,36 C280,52 250,28 214,48 C180,64 150,34 110,52 C70,66 40,40 -10,50 Z","#3f9a4c")
    s+=path("M-10,0 L320,0 L320,22 C270,36 230,14 190,30 C150,46 110,18 70,32 C40,42 20,28 -10,34 Z","#2f7a3e")
    s+=path("M0,150 C60,140 120,152 180,146 C240,140 290,150 320,146 L320,200 L0,200 Z","url(#fl)")
    s+=path("M120,200 C140,176 160,166 176,158 C190,166 196,180 214,200 Z","#d9b77a")
    s+=path("M146,200 C156,184 166,176 176,170 C184,178 188,188 196,200 Z","#e9cf96",op=.8)
    # bushes
    for x,y in ((60,170),(270,172),(92,190)):
        s+=f'<ellipse cx="{x}" cy="{y}" rx="26" ry="14" fill="#4aa650"/><ellipse cx="{x-6}" cy="{y-5}" rx="12" ry="5" fill="#7fd06a" opacity=".7"/>'
    # mushrooms
    for x,y,s_ in ((238,186,1),(250,192,.7)):
        s+=f'<rect x="{x-3*s_}" y="{y-9*s_}" width="{6*s_}" height="{10*s_}" rx="2" fill="#fff3dc"/><path d="M{x-11*s_},{y-8*s_} Q{x},{y-26*s_} {x+11*s_},{y-8*s_} Z" fill="#ef4a5a"/><circle cx="{x-3*s_}" cy="{y-15*s_}" r="{1.8*s_}" fill="#fff"/><circle cx="{x+4*s_}" cy="{y-13*s_}" r="{1.5*s_}" fill="#fff"/>'
    s+=''.join(grass(x,y,"#3d7f46") for x,y in ((20,192),(130,194),(220,172),(300,192)))
    s+=''.join(flower(x,y,c,.8) for x,y,c in ((200,188,"#ffd166"),(112,180,"#fff")))
    return svg(frame(s),d)

def hilltop():
    d=lg("sky",[(0,"#5a5fb8"),(.45,"#ee7fa0"),(1,"#ffc27a")],0,150)+rg("sun",220,128,60,[(0,"#fff2a8",1),(1,"#ffb86b",0)])+lg("h3",[(0,"#5a4a8a"),(1,"#43386e")],100,200)+lg("h1",[(0,"#5fa05d"),(1,"#3b7a4a")],140,200)
    s=rect("url(#sky)")
    for x,y,r in ((40,20,1.4),(90,40,1),(150,16,1.2),(200,34,1),(270,14,1.4),(300,44,1),(20,58,1)):
        s+=f'<circle cx="{x}" cy="{y}" r="{r}" fill="#fff" opacity=".85"/>'
    s+=f'<circle cx="220" cy="128" r="60" fill="url(#sun)"/><circle cx="220" cy="128" r="24" fill="#fff0a0"/>'
    s+=cloud(80,70,1.1,"#ffd0dc",.9)+cloud(270,60,.9,"#ffe0d0",.9)+cloud(150,96,.8,"#ffb8c4",.8)
    s+=path("M0,128 C40,108 80,112 120,122 C170,134 210,118 250,126 C280,132 300,120 320,124 L320,200 L0,200 Z","url(#h3)")
    s+=path("M0,160 C60,138 130,134 190,148 C240,160 290,150 320,142 L320,200 L0,200 Z","url(#h1)")
    s+=path("M0,160 C60,138 130,134 190,148 C240,160 290,150 320,142","none","#a6e88c",3,.6)
    s+=''.join(grass(x,y,"#8fd07a") for x,y in ((40,172),(100,160),(180,176),(260,166),(300,182),(70,190)))
    s+=''.join(flower(x,y,c,.8) for x,y,c in ((60,184,"#ffd0dc"),(140,180,"#ffe27a"),(220,186,"#fff"),(290,170,"#ffd0dc")))
    # little tree silhouette
    s+=f'<rect x="58" y="116" width="6" height="26" fill="#3b2f5e"/><circle cx="61" cy="106" r="16" fill="#3b2f5e"/><circle cx="50" cy="114" r="11" fill="#3b2f5e"/><circle cx="72" cy="114" r="11" fill="#3b2f5e"/>'
    return svg(frame(s),d)

def cave_inside():
    d=lg("w",[(0,"#4a4478"),(1,"#2e2a52")],0,200)+lg("fl",[(0,"#5a5384"),(1,"#3b3566")],140,200)+rg("g1",96,150,60,[(0,"#8fe7ff",.8),(1,"#8fe7ff",0)])+rg("g2",236,140,56,[(0,"#ff9be0",.7),(1,"#ff9be0",0)])
    s=rect("url(#w)")
    s+=path("M0,0 L320,0 L320,30 C290,48 270,30 246,46 C220,62 200,34 170,44 C140,54 120,32 90,46 C60,58 40,36 0,48 Z","#3b3566")
    # stalactites (soft, rounded)
    for x,h in ((30,46),(74,62),(130,40),(190,58),(250,44),(296,60)):
        s+=f'<path d="M{x-12},20 C{x-8},{h*.6} {x-3},{h-4} {x},{h+6} C{x+3},{h-4} {x+8},{h*.6} {x+12},20 Z" fill="#5a5384"/><path d="M{x-6},24 C{x-4},{h*.6} {x-2},{h-6} {x},{h-2}" stroke="#8a84b8" stroke-width="2" fill="none" opacity=".6" stroke-linecap="round"/>'
    s+=path("M0,150 C60,138 130,150 190,144 C250,138 290,148 320,142 L320,200 L0,200 Z","url(#fl)")
    s+=f'<circle cx="96" cy="150" r="60" fill="url(#g1)"/><circle cx="236" cy="140" r="56" fill="url(#g2)"/>'
    # crystals
    def cry(x,y,h,col,lt):
        return f'<path d="M{x-8},{y} L{x-5},{y-h*.7} L{x},{y-h} L{x+5},{y-h*.7} L{x+8},{y} Z" fill="{col}"/><path d="M{x-3},{y} L{x-2},{y-h*.7} L{x},{y-h} L{x+1},{y} Z" fill="{lt}" opacity=".7"/>'
    s+=cry(84,160,34,"#5fd3f2","#d6f7ff")+cry(100,164,48,"#5fd3f2","#d6f7ff")+cry(116,160,26,"#7be3f7","#e8fbff")
    s+=cry(226,150,32,"#f27fd0","#ffd6f3")+cry(242,154,44,"#f27fd0","#ffd6f3")+cry(256,150,24,"#ff9be0","#ffe8f8")
    s+=rock(40,176,22,10,"#7a74a8")+rock(168,184,18,8,"#7a74a8")+rock(290,180,16,8,"#7a74a8")
    for x,y,s_ in ((160,166,1),(174,170,.7)):
        s+=f'<rect x="{x-3*s_}" y="{y-9*s_}" width="{6*s_}" height="{10*s_}" rx="2" fill="#fff3dc"/><path d="M{x-11*s_},{y-8*s_} Q{x},{y-26*s_} {x+11*s_},{y-8*s_} Z" fill="#7be3b0"/><circle cx="{x-3*s_}" cy="{y-15*s_}" r="{1.8*s_}" fill="#fff"/>'
    for x,y in ((60,70),(150,96),(210,80),(280,100),(20,110)):
        s+=f'<circle cx="{x}" cy="{y}" r="1.6" fill="#ffe27a" opacity=".8"/>'
    return svg(frame(s),d)

def room():
    d=lg("wall",[(0,"#ffe9c9"),(1,"#ffd7a8")],0,150)+lg("fl",[(0,"#c98f5a"),(1,"#a87444")],150,200)+lg("win",[(0,"#79c8ff"),(1,"#d6f1ff")],40,100)
    s=rect("url(#wall)")
    for x in range(10,320,30): s+=f'<path d="M{x},0 L{x},150" stroke="#ffcf9a" stroke-width="2" opacity=".5"/>'
    s+=rect("url(#fl)",0,150,320,50)+'<path d="M0,150 L320,150" stroke="#8a5a33" stroke-width="4"/>'
    for x in range(0,320,40): s+=f'<path d="M{x},152 L{x-14},200" stroke="#8a5a33" stroke-width="1.5" opacity=".45"/>'
    # window
    s+=f'<rect x="124" y="30" width="72" height="68" rx="6" fill="#fff3dc"/><rect x="130" y="36" width="60" height="56" rx="3" fill="url(#win)"/>'
    s+=cloud(150,56,.6)+'<circle cx="176" cy="52" r="7" fill="#ffe27a"/>'
    s+='<path d="M160,36 L160,92 M130,64 L190,64" stroke="#fff3dc" stroke-width="4"/>'
    s+=path("M118,28 C126,60 124,80 118,100 L132,100 C128,80 130,56 136,28 Z","#ff8fa3")+path("M202,28 C194,60 196,80 202,100 L188,100 C192,80 190,56 184,28 Z","#ff8fa3")
    # bookshelf
    s+='<rect x="16" y="44" width="62" height="106" rx="4" fill="#a87444"/><rect x="21" y="49" width="52" height="96" rx="2" fill="#7a5230"/>'
    for y in (80,112): s+=f'<rect x="19" y="{y}" width="56" height="5" fill="#a87444"/>'
    cols=["#ef4a5a","#5fa8f2","#ffd166","#7fd06a","#c18bf2","#ff9bc0"]
    for row,(y,n) in enumerate(((50,6),(86,6),(118,5))):
        x=23
        for i in range(n):
            w=6+((i*3+row)%3)*2; h=24+((i+row)%3)*3
            s+=f'<rect x="{x}" y="{y+(30-h) if row<2 else y+(26-h)+4}" width="{w}" height="{h}" rx="1.5" fill="{cols[(i+row)%6]}"/>'; x+=w+1.5
    # bed
    s+=f'<rect x="222" y="104" width="86" height="44" rx="8" fill="#8a5a33"/><rect x="226" y="108" width="78" height="30" rx="8" fill="#6fb3f2"/><rect x="230" y="102" width="28" height="18" rx="8" fill="#fff"/><path d="M226,126 C250,118 280,134 304,124 L304,138 L226,138 Z" fill="#ffd166"/>'
    s+='<rect x="224" y="144" width="6" height="10" fill="#8a5a33"/><rect x="300" y="144" width="6" height="10" fill="#8a5a33"/>'
    # rug
    s+='<ellipse cx="160" cy="180" rx="90" ry="14" fill="#ef7a8a"/><ellipse cx="160" cy="180" rx="74" ry="10" fill="#ffc2c8"/><ellipse cx="160" cy="180" rx="50" ry="6" fill="#ef7a8a"/>'
    # lamp + plant
    s+='<rect x="92" y="126" width="22" height="24" rx="3" fill="#a87444"/><rect x="100" y="106" width="6" height="22" fill="#6a4a2c"/><path d="M90,106 L116,106 L110,88 L96,88 Z" fill="#ffe27a"/><ellipse cx="103" cy="108" rx="24" ry="9" fill="#ffe27a" opacity=".25"/>'
    s+='<path d="M200,150 L206,130 L226,130 L232,150 Z" fill="#d9774a" transform="translate(-6 0)"/>'
    s+='<path d="M213,130 C206,112 200,108 196,100 M213,130 C214,110 214,104 216,94 M213,130 C222,114 230,110 234,104" stroke="#3f8f50" stroke-width="3" fill="none" stroke-linecap="round"/><ellipse cx="196" cy="98" rx="7" ry="4" fill="#5cb457" transform="rotate(-40 196 98)"/><ellipse cx="216" cy="92" rx="7" ry="4" fill="#5cb457" transform="rotate(-80 216 92)"/><ellipse cx="234" cy="102" rx="7" ry="4" fill="#5cb457" transform="rotate(40 234 102)"/>'
    return svg(frame(s),d)

BG=[("Sunny meadow",meadow),("Riverbank",riverbank),("Forest",forest),("Hilltop sunset",hilltop),("Cave inside",cave_inside),("Cozy room",room)]
if __name__=="__main__":
    cards=''.join(f'<div class="c">{f()}<div class="n">{n}</div></div>' for n,f in BG)
    open("bgs2.html","w").write(f'<html><body style="margin:0;background:#3c4060;font-family:Arial,sans-serif"><div style="padding:22px 26px;color:#fff;font-size:26px">BACKGROUNDS (smooth style)</div><div style="display:grid;grid-template-columns:repeat(2,640px);gap:22px;padding:0 26px 26px">{cards}</div><style>.c{{background:#f1ead8;border-radius:14px;padding:10px 10px 12px;text-align:center}}.c svg{{width:100%;display:block;border-radius:10px}}.n{{font-size:22px;color:#1e2236;font-weight:bold;padding-top:6px}}</style></body></html>')
