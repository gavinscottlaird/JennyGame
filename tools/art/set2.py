# One-outline character set: each character's same-colour parts share one silhouette.
INK="#1e2236"
def svg(body,defs=""): return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240"><defs>{defs}</defs>{body}</svg>'
def ug(i,top,bot,y1=20,y2=230):  # gradient in page space, so every part matches
    return f'<linearGradient id="{i}" gradientUnits="userSpaceOnUse" x1="0" y1="{y1}" x2="0" y2="{y2}"><stop offset="0" stop-color="{top}"/><stop offset="1" stop-color="{bot}"/></linearGradient>'
def sil(parts,fill,sw=7):
    a=''.join(f'<{p} fill="{INK}" stroke="{INK}" stroke-width="{sw}" stroke-linejoin="round"/>' for p in parts)
    b=''.join(f'<{p} fill="{fill}"/>' for p in parts)
    return a+b
def clip(i,parts): return f'<clipPath id="{i}">'+''.join(f'<{p}/>' for p in parts)+'</clipPath>'
def inner(shape,clip_id,w=3): return f'<g clip-path="url(#{clip_id})"><{shape} fill="none" stroke="{INK}" stroke-width="{w}"/></g>'
def within(clip_id,content): return f'<g clip-path="url(#{clip_id})">{content}</g>'
def shadow(cx=120,rx=84): return f'<ellipse cx="{cx}" cy="226" rx="{rx}" ry="7" fill="#000" opacity=".13"/>'
def E(cx,cy,rx,ry,rot=0): return f'ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}"'+(f' transform="rotate({rot} {cx} {cy})"' if rot else '')
def C(cx,cy,r): return f'circle cx="{cx}" cy="{cy}" r="{r}"'
def P(d): return f'path d="{d}"'
def tear(x,y,s=1,fill="#8fd0ff",st="#3b8fd6"):
    return f'<path d="M{x},{y} C{x-7*s},{y+12*s} {x-5*s},{y+22*s} {x+1*s},{y+22*s} C{x+7*s},{y+22*s} {x+7*s},{y+12*s} {x},{y} Z" fill="{fill}" stroke="{st}" stroke-width="2"/>'

# ---------------- Dot (happy) ----------------
def dot():
    G1,G0,GD="#a9e8b3","#72c788","#4f9e69"; CREAM="#fbf0c8"; SPOT="#5aa874"
    B=("M6,104 C18,122 52,136 86,124 C100,114 124,100 146,108 "
       "C156,110 168,72 176,42 "
       "C176,26 188,16 202,17 C214,18 220,26 222,33 C224,41 218,47 209,47 C202,47 196,48 193,53 "
       "C184,80 174,108 170,130 C168,138 166,144 164,150 "
       "C162,170 160,186 161,196 C162,202 164,206 164,212 C164,217 161,218 156,218 L146,218 C141,218 140,216 140,212 "
       "C140,206 142,200 142,192 C142,186 140,183 136,181 "
       "C126,186 110,186 100,181 "
       "C97,186 96,194 96,200 C96,206 98,208 98,212 C98,217 95,218 90,218 L80,218 C75,218 74,216 74,212 "
       "C74,206 77,198 76,190 C75,180 70,170 70,162 C60,152 22,136 6,104 Z")
    defs=ug("dg",G1,"#66b97d",20,220)+ug("dfl",G0,GD,170,220)+\
         f'<linearGradient id="dth" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{CREAM}" stop-opacity=".95"/><stop offset=".85" stop-color="{CREAM}" stop-opacity=".9"/><stop offset="1" stop-color="{CREAM}" stop-opacity="0"/></linearGradient>'+clip("dc",[P(B)])
    def far(x0,x1):
        d=f"M{x0},172 L{x1},172 L{x1},212 C{x1},217 {x1-3},218 {x1-8},218 L{x0+8},218 C{x0+3},218 {x0},217 {x0},212 Z"
        return sil([P(d)],"url(#dfl)")
    def nails(xs): return ''.join(f'<ellipse cx="{x}" cy="213" rx="2.6" ry="3.3" fill="#fff6d6" stroke="{INK}" stroke-width="1.5"/>' for x in xs)
    body=sil([P(B)],"url(#dg)")
    det=within("dc",
        '<ellipse cx="116" cy="110" rx="28" ry="5" fill="#fff" opacity=".25" transform="rotate(-8 116 110)"/>'
        '<ellipse cx="189" cy="24" rx="7.5" ry="3" fill="#fff" opacity=".35" transform="rotate(-20 189 24)"/>'
        f'<path d="M100,181 C94,168 84,162 72,162" stroke="{GD}" stroke-width="2.4" fill="none" stroke-linecap="round" opacity=".55"/>'
        f'<path d="M136,181 C140,168 150,160 162,156" stroke="{GD}" stroke-width="2.4" fill="none" stroke-linecap="round" opacity=".55"/>'
        '<path d="M200,50 C188,80 176,110 170,150 L156,150 C162,110 174,80 186,50 Z" fill="url(#dth)"/>'
        f'<path d="M98,181 C110,186 126,186 138,181 C130,176 122,175 118,175 C114,175 106,176 98,181 Z" fill="{CREAM}" opacity=".85"/>'
        + ''.join(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{SPOT}" opacity=".55"/>' for x,y,r in ((100,120,5),(120,112,5.5),(138,116,4),(92,134,3.5),(114,130,3),(56,131,3),(38,131,2.4)))
        + ''.join(f'<path d="M{x},{y} q4,-4 8,0" stroke="{SPOT}" stroke-width="1.8" fill="none" stroke-linecap="round" opacity=".7"/>' for x,y in ((167,84),(163,98),(158,112))))
    face=(f'<ellipse cx="199" cy="31" rx="6" ry="7" fill="#fff" stroke="{INK}" stroke-width="2"/>'
          f'<ellipse cx="200.6" cy="32.6" rx="3.7" ry="5" fill="{INK}"/><circle cx="202.2" cy="29.6" r="1.9" fill="#fff"/><circle cx="199.4" cy="35.4" r=".9" fill="#fff"/>'
          '<ellipse cx="197" cy="41" rx="4.6" ry="2.9" fill="#ff9bab" opacity=".8"/>'
          f'<path d="M205,39.5 Q211.5,47.5 218,39.5 Z" fill="#7a2d3d" stroke="{INK}" stroke-width="2" stroke-linejoin="round"/>'
          '<ellipse cx="211.5" cy="42.6" rx="2.9" ry="1.9" fill="#ff8fa3"/>'
          f'<ellipse cx="219" cy="26" rx="1.4" ry="1" fill="{INK}"/>')
    return svg(shadow(112,76)+far(86,108)+far(126,148)+nails((104,))+nails((133,))+body+det+nails((80,86,92))+nails((146,152,158))+face,defs)

# ---------------- Bao the Panda (sad) ----------------
def panda():
    K="#2a2b3a"
    ears=[C(62,42,23),C(178,42,23)]; head=E(120,94,70,58); body=E(120,170,55,50)
    arms=[E(66,166,17,34,18),E(174,166,17,34,-18)]; feet=[E(86,213,24,13),E(154,213,24,13)]
    parts=ears+[body]+arms+feet+[head]
    defs=ug("pw","#ffffff","#e2e5f0")+clip("pc",parts)+clip("pb",[body])
    s=sil(parts,"url(#pw)")
    black=within("pc",''.join(f'<{p} fill="{K}"/>' for p in ears+arms+feet))
    s+=black+'<circle cx="62" cy="42" r="10" fill="#555768"/><circle cx="178" cy="42" r="10" fill="#555768"/>'
    s+=f'<{head} fill="url(#pw)"/>'+inner(head,"pb")  # head sits in front, chin line on the body
    s+=(f'<ellipse cx="90" cy="98" rx="19" ry="26" transform="rotate(28 90 98)" fill="{K}"/><ellipse cx="150" cy="98" rx="19" ry="26" transform="rotate(-28 150 98)" fill="{K}"/>'
        '<ellipse cx="70" cy="128" rx="11" ry="7" fill="#ff9bab" opacity=".5"/><ellipse cx="170" cy="128" rx="11" ry="7" fill="#ff9bab" opacity=".5"/>'
        + ''.join(f'<circle cx="{x}" cy="100" r="10" fill="#fff"/><circle cx="{x+1}" cy="103" r="6.5" fill="{K}"/><circle cx="{x+3}" cy="100" r="2.8" fill="#fff"/><circle cx="{x-1}" cy="106" r="1.4" fill="#fff"/>' for x in (92,148))
        + tear(88,114,.85,"#7fc8ff")+tear(160,114,.85,"#7fc8ff")
        + f'<path d="M64,74 Q84,64 104,58" stroke="{K}" stroke-width="5" fill="none" stroke-linecap="round"/><path d="M176,74 Q156,64 136,58" stroke="{K}" stroke-width="5" fill="none" stroke-linecap="round"/>'
        + f'<path d="M108,112 Q120,104 132,112 Q127,124 120,125 Q113,124 108,112 Z" fill="{K}"/><ellipse cx="116" cy="111" rx="3" ry="1.6" fill="#fff" opacity=".6"/>'
        + f'<path d="M104,144 Q120,128 136,144" stroke="{K}" stroke-width="4" fill="none" stroke-linecap="round"/>')
    return svg(shadow()+s,defs)

# ---------------- Kiko the Cat (angry) ----------------
def kiko():
    S="#d27a38"; Pk="#f08fa0"
    ears=[P("M62,76 L54,16 L108,50 Z"),P("M178,76 L186,16 L132,50 Z")]
    head=E(120,100,72,56); body=E(120,172,53,48); paws=[E(94,214,20,11),E(146,214,20,11)]
    tail=P("M160,198 C208,202 228,170 216,130 C212,116 198,114 197,124 C206,152 196,180 160,180 Z")
    parts=[tail,body]+paws+ears+[head]
    defs=ug("kg","#ffbd80","#ea8f44")+clip("kb",[body])+clip("kt",[tail])
    s=sil(parts,"url(#kg)")
    s+=inner(P("M160,198 C208,202 228,170 216,130"),"kb")  # (no-op safety)
    s+=inner(body,"kt")                                      # body edge over the tail
    s+=within("kb",'<ellipse cx="120" cy="192" rx="30" ry="28" fill="#fff1dc"/>')
    s+=inner(head,"kb")+''.join(inner(p,"kb") for p in paws)
    s+=f'<path d="M218,160 L210,158 M220,144 L212,146 M212,130 L206,134" stroke="{S}" stroke-width="3" stroke-linecap="round"/>'
    s+=f'<path d="M66,64 L62,32 L92,52 Z" fill="{Pk}"/><path d="M174,64 L178,32 L148,52 Z" fill="{Pk}"/>'
    s+=''.join(f'<path d="{d}" stroke="{S}" stroke-width="5" fill="none" stroke-linecap="round"/>' for d in ("M120,48 L120,64","M104,52 L106,64","M136,52 L134,64","M52,102 l12,3","M52,114 l12,0","M188,102 l-12,3","M188,114 l-12,0"))
    s+=''.join(f'<ellipse cx="{x}" cy="100" rx="17" ry="15" fill="#fff" stroke="{INK}" stroke-width="2.5"/><ellipse cx="{x+d}" cy="102" rx="7" ry="9" fill="#2f7d4f"/><ellipse cx="{x+d}" cy="102" rx="3.4" ry="6" fill="{INK}"/><circle cx="{x+d+2}" cy="99" r="2" fill="#fff"/>' for x,d in ((90,4),(150,-4)))
    s+='<path d="M66,76 L116,100 L116,52 L66,52 Z" fill="url(#kg)"/><path d="M174,76 L124,100 L124,52 L174,52 Z" fill="url(#kg)"/>'
    s+=''.join(f'<path d="{d}" stroke="{S}" stroke-width="5" fill="none" stroke-linecap="round"/>' for d in ("M120,48 L120,64","M104,52 L106,64","M136,52 L134,64"))
    s+=f'<path d="M66,78 L114,100" stroke="{INK}" stroke-width="6.5" stroke-linecap="round"/><path d="M174,78 L126,100" stroke="{INK}" stroke-width="6.5" stroke-linecap="round"/>'
    s+=''.join(f'<path d="{d}" stroke="{INK}" stroke-width="2.2" fill="none" stroke-linecap="round"/>' for d in ("M62,124 L26,116","M62,132 L26,136","M178,124 L214,116","M178,132 L214,136"))
    s+=f'<path d="M112,118 L128,118 L120,128 Z" fill="{Pk}" stroke="{INK}" stroke-width="2.2" stroke-linejoin="round"/>'
    s+=(f'<rect x="100" y="134" width="40" height="17" rx="6" fill="#fff" stroke="{INK}" stroke-width="3"/>'
        + ''.join(f'<path d="M{x},134 L{x},151" stroke="{INK}" stroke-width="2"/>' for x in (110,120,130)) + f'<path d="M100,142.5 L140,142.5" stroke="{INK}" stroke-width="2"/>')
    s+='<g stroke="#e0323f" stroke-width="5" fill="none" stroke-linecap="round"><path d="M188,28 q6,-2 6,-10 M188,28 q-8,2 -8,-6"/><path d="M202,42 q-6,-2 -6,6 M202,42 q8,-2 8,-8"/></g>'
    return svg(shadow()+s,defs)

# ---------------- Buzz the Bee (excited) ----------------
def buzz():
    K="#2a2b3a"
    wings=''.join(f'<ellipse cx="{x}" cy="106" rx="30" ry="52" transform="rotate({r} {x} 106)" fill="#d6edff" stroke="#8ec3ee" stroke-width="3" opacity=".95"/>' for x,r in ((58,-30),(182,30)))
    head=E(120,92,56,48); body=E(120,156,58,60)
    arms=[E(62,132,11,20,35),E(178,132,11,20,-35)]
    legs=[f'rect x="88" y="206" width="12" height="20" rx="5"',f'rect x="140" y="206" width="12" height="20" rx="5"']
    sting=P("M112,212 L120,232 L128,212 Z")
    parts=legs+[sting,body]+arms+[head]
    defs=ug("yg","#ffe788","#ffbe2a")+clip("yb",[body])+clip("yc",parts)
    s=wings+sil(parts,"url(#yg)")
    s+=within("yc",''.join(f'<{p} fill="{K}"/>' for p in legs+[sting]))
    s+=within("yb",f'<rect x="50" y="152" width="140" height="20" fill="{K}"/><rect x="50" y="186" width="140" height="18" fill="{K}"/>')
    s+=f'<{head} fill="url(#yg)"/>'+inner(head,"yb")+''.join(inner(a,"yb") for a in arms)
    s+=(f'<path d="M96,50 Q82,26 66,22" stroke="{INK}" stroke-width="5" fill="none" stroke-linecap="round"/><circle cx="64" cy="22" r="7" fill="{K}"/>'
        f'<path d="M144,50 Q158,26 174,22" stroke="{INK}" stroke-width="5" fill="none" stroke-linecap="round"/><circle cx="176" cy="22" r="7" fill="{K}"/>')
    s+='<ellipse cx="74" cy="112" rx="10" ry="6.5" fill="#ff8f9f" opacity=".75"/><ellipse cx="166" cy="112" rx="10" ry="6.5" fill="#ff8f9f" opacity=".75"/>'
    s+=''.join(f'<ellipse cx="{x}" cy="88" rx="16" ry="20" fill="#fff" stroke="{INK}" stroke-width="3"/><ellipse cx="{x}" cy="90" rx="10.5" ry="13.5" fill="{K}"/><circle cx="{x+4}" cy="83" r="5" fill="#fff"/><circle cx="{x-4}" cy="95" r="2.6" fill="#fff"/>' for x in (98,142))
    s+=f'<path d="M80,58 Q98,46 114,56" stroke="{INK}" stroke-width="4.5" fill="none" stroke-linecap="round"/><path d="M126,56 Q142,46 160,58" stroke="{INK}" stroke-width="4.5" fill="none" stroke-linecap="round"/>'
    s+=(f'<path d="M98,112 Q120,148 142,112 Z" fill="#7a2d3d" stroke="{INK}" stroke-width="3.5" stroke-linejoin="round"/>'
        '<path d="M107,132 Q120,121 133,132 Q120,143 107,132 Z" fill="#ff8fa3"/><path d="M102,113 Q120,119 138,113 L136,108 Q120,113 104,108 Z" fill="#fff"/>')
    def star(x,y,r): return f'<path d="M{x},{y-r} L{x+r*.28},{y-r*.28} L{x+r},{y} L{x+r*.28},{y+r*.28} L{x},{y+r} L{x-r*.28},{y+r*.28} L{x-r},{y} L{x-r*.28},{y-r*.28} Z" fill="#fff6a8" stroke="#f0b92b" stroke-width="1.5" stroke-linejoin="round"/>'
    s+=star(28,62,13)+star(212,72,10)+star(30,154,8)+star(210,166,12)
    return svg(shadow()+s,defs)

# ---------------- Pip the Penguin (scared) ----------------
def pip():
    body=E(120,140,64,80); flips=[E(52,118,15,42,-38),E(188,118,15,42,38)]; feet=[E(92,221,25,10),E(148,221,25,10)]
    parts=feet+flips+[body]
    defs=ug("ng","#56679f","#2b3563")+clip("nb",[body])+clip("nf",feet)
    s=sil(parts,"url(#ng)")
    s+=within("nf",''.join(f'<{f} fill="#ff9a2e"/>' for f in feet))
    s+=within("nb",'<ellipse cx="120" cy="168" rx="44" ry="58" fill="#f7f9ff"/><circle cx="99" cy="94" r="30" fill="#f7f9ff"/><circle cx="141" cy="94" r="30" fill="#f7f9ff"/><ellipse cx="120" cy="108" rx="34" ry="24" fill="#f7f9ff"/>')
    s+=''.join(inner(f,"nb") for f in flips)+''.join(inner(f,"nb") for f in feet)
    s+=''.join(f'<ellipse cx="{x}" cy="90" rx="15" ry="19" fill="#fff" stroke="{INK}" stroke-width="3"/><circle cx="{x}" cy="91" r="3.6" fill="{INK}"/><circle cx="{x+1.5}" cy="89.5" r="1.2" fill="#fff"/>' for x in (100,140))
    s+=f'<path d="M82,62 Q96,52 112,56" stroke="{INK}" stroke-width="4.5" fill="none" stroke-linecap="round"/><path d="M158,62 Q144,52 128,56" stroke="{INK}" stroke-width="4.5" fill="none" stroke-linecap="round"/>'
    s+=(f'<ellipse cx="120" cy="133" rx="11" ry="12" fill="#5a1f2c" stroke="{INK}" stroke-width="2.5"/>'
        f'<path d="M104,112 Q120,106 136,112 Q132,126 120,128 Q108,126 104,112 Z" fill="#ffa63a" stroke="{INK}" stroke-width="3" stroke-linejoin="round"/>')
    s+=tear(60,54)+tear(182,46)
    s+=''.join(f'<path d="{d}" stroke="#8a93bf" stroke-width="3.5" fill="none" stroke-linecap="round"/>' for d in ("M18,100 l-8,-6 M16,124 l-10,0 M18,148 l-8,6","M222,100 l8,-6 M224,124 l10,0 M222,148 l8,6"))
    return svg(shadow()+s,defs)

# ---------------- Bun the Bunny (shy) ----------------
def bun():
    Pk="#f6a9b4"; CR="#fff1dc"; FT="#f4dfc3"
    earL=E(88,56,19,46,-8); earR=E(170,80,18,44,62); head=E(120,116,62,50); body=E(120,180,50,44)
    feet=[E(90,218,26,11),E(150,218,26,11)]; tail=C(176,198,14)
    parts=[tail,earL,earR]+feet+[body,head]
    defs=ug("bg","#e6c093","#c28c58")+clip("bb",[body])+clip("bt",[tail])+clip("bL",[earL])+clip("bR",[earR])+clip("bh",[head])+clip("bc",parts)
    s=sil(parts,"url(#bg)")
    s+=within("bc",f'<{tail} fill="#fff6e8"/>'+''.join(f'<{f} fill="{FT}"/>' for f in feet))
    s+=inner(body,"bt")
    s+=f'<ellipse cx="88" cy="60" rx="9" ry="33" transform="rotate(-8 88 60)" fill="{Pk}"/><ellipse cx="172" cy="82" rx="8.5" ry="31" transform="rotate(62 172 82)" fill="{Pk}"/>'
    s+=inner(head,"bL")+inner(head,"bR")
    s+=within("bb",f'<ellipse cx="120" cy="194" rx="28" ry="26" fill="{CR}"/>')+inner(head,"bb")+''.join(inner(f,"bb") for f in feet)
    s+=f'<ellipse cx="120" cy="136" rx="27" ry="19" fill="{CR}"/>'
    s+=''.join(f'<ellipse cx="{x}" cy="132" rx="14" ry="8.5" fill="#ff8fa3" opacity=".85"/>'+''.join(f'<path d="M{x-8+i*6},129 l-2,7" stroke="#ff6f8a" stroke-width="2" stroke-linecap="round"/>' for i in range(3)) for x in (72,168))
    s+=''.join(f'<ellipse cx="{x}" cy="110" rx="13" ry="16" fill="#fff" stroke="{INK}" stroke-width="2.8"/><ellipse cx="{x-4}" cy="116" rx="7.5" ry="9" fill="#3a2a22"/><circle cx="{x-2}" cy="112" r="2.8" fill="#fff"/><circle cx="{x-6}" cy="119" r="1.4" fill="#fff"/>' for x in (94,146))
    s+=''.join(f'<path d="M{x-12},92 q12,-8 24,0" stroke="{INK}" stroke-width="3" fill="none" stroke-linecap="round"/>' for x in (94,146))
    s+=f'<path d="M113,128 Q120,123 127,128 Q124,135 120,135 Q116,135 113,128 Z" fill="{Pk}" stroke="{INK}" stroke-width="2"/>'
    s+=f'<path d="M108,144 Q114,150 120,144 Q126,150 132,144" stroke="{INK}" stroke-width="3" fill="none" stroke-linecap="round"/>'
    s+=''.join(f'<ellipse cx="{x}" cy="160" rx="15" ry="13" fill="{FT}" stroke="{INK}" stroke-width="3"/>' for x in (102,138))
    s+=f'<path d="M96,154 l0,8 M102,152 l0,9 M108,154 l0,8 M132,154 l0,8 M138,152 l0,9 M144,154 l0,8" stroke="{INK}" stroke-width="2" stroke-linecap="round"/>'
    s+=tear(184,92,.9)
    return svg(shadow()+s,defs)

SET=[("Dot the Dino","Happy",dot),("Bao the Panda","Sad",panda),("Kiko the Cat","Angry",kiko),("Buzz the Bee","Excited",buzz),("Pip the Penguin","Scared",pip),("Bun the Bunny","Shy",bun)]
if __name__=="__main__":
    import os; os.makedirs("svg2",exist_ok=True)
    cards=""
    for n,e,f in SET:
        s=f(); open("svg2/"+n.split()[0].lower()+".svg","w").write(s)
        cards+=f'<div class="c">{s}<div class="n">{n}</div><div class="e">{e}</div></div>'
    open("set2.html","w").write(f'<html><body style="margin:0;background:#3c4060;font-family:Arial,sans-serif"><div style="padding:22px 26px;color:#fff;font-size:26px">CHARACTERS (one-outline style)</div><div style="display:grid;grid-template-columns:repeat(3,420px);gap:22px;padding:0 26px 26px">{cards}</div><style>.c{{background:#f1ead8;border-radius:14px;padding:10px 10px 12px;text-align:center}}.c svg{{width:100%;display:block}}.n{{font-size:22px;color:#1e2236;font-weight:bold}}.e{{font-size:18px;color:#6b6f8c}}</style></body></html>')
    open("dot5.html","w").write(f'<html><body style="margin:0;background:#f1ead8"><div style="width:720px;height:720px">{dot()}</div></body></html>')
