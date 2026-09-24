/// scr_art_chars -- pixel art for the four player avatars.
///
/// DESIGN LOCK (from the spec): every avatar is drawn on the SAME canvas,
/// CHAR_GRID_W x CHAR_GRID_H pixels. Nothing may stick out of that canvas,
/// so all four characters move and collide identically.
///
/// The sauropod's long neck is curled INSIDE the canvas on purpose. That keeps
/// it from clipping through low ceilings or covering the action buttons above
/// the room objects (see "hit" below for the tight collision box).

#macro CHAR_GRID_W 16
#macro CHAR_GRID_H 20

/// @desc Builds the avatar table once and caches it in a global.
///       Each entry: { label, map, pal, hit }
///       map  = array of CHAR_GRID_H strings, each CHAR_GRID_W chars, "." = see-through
///       pal  = struct of single-char -> colour
///       hit  = tight collision box in grid pixels [x1, y1, x2, y2].
///              This is the VISIBLE body only, so the dinosaur's neck never
///              pushes its hitbox wider than the other characters.
function art_chars() {
    if (variable_global_exists("art_chars_cache")) return global.art_chars_cache;

    // shared ink colour so every avatar reads as one set
    var k = make_colour_rgb(30, 34, 54);

    // ---- robot ----
    var r_m = make_colour_rgb(201, 212, 226);
    var r_d = make_colour_rgb(125, 140, 163);
    var r_v = make_colour_rgb(73, 224, 232);
    var r_y = make_colour_rgb(255, 215, 0);

    // ---- cat ----
    var c_o = make_colour_rgb(242, 162, 92);
    var c_w = make_colour_rgb(250, 240, 226);
    var c_p = make_colour_rgb(232, 130, 146);
    var c_g = make_colour_rgb(110, 203, 99);

    // ---- kid ----
    var d_s = make_colour_rgb(240, 198, 160);   // skin
    var d_h = make_colour_rgb(110, 72, 48);     // hair
    var d_t = make_colour_rgb(86, 140, 232);    // shirt
    var d_p = make_colour_rgb(64, 70, 110);     // trousers
    var d_e = make_colour_rgb(40, 60, 90);      // eyes
    var d_r = make_colour_rgb(224, 110, 104);   // shoes

    // ---- sauropod ----
    var s_g = make_colour_rgb(118, 190, 132);   // skin
    var s_d = make_colour_rgb(78, 148, 100);    // shade
    var s_b = make_colour_rgb(238, 230, 180);   // belly
    var s_e = make_colour_rgb(40, 60, 50);      // eye

    global.art_chars_cache = {
        robot : {
            label : "Robot",
            pal   : { k: k, m: r_m, d: r_d, v: r_v, y: r_y },
            hit   : [3, 2, 12, 19],
            map   : [
                "......kkkk......",
                "......kyyk......",
                ".....kkyykk.....",
                "....kmmmmmmk....",
                "...kmmmmmmmmk...",
                "...kmvvvvvvmk...",
                "...kmvkvvkvmk...",
                "...kmvvvvvvmk...",
                "...kmmvvvvmmk...",
                "...kkmmmmmmkk...",
                ".....kmmmmk.....",
                "..kkkmmmmmmkkk..",
                "..kdkmyyyymkdk..",
                "..kdkmyvvymkdk..",
                "..kdkmyyyymkdk..",
                "..kkkmmmmmmkkk..",
                "....kmmmmmmk....",
                "....kmk..kmk....",
                "....kmk..kmk....",
                "...kddk..kddk..."
            ]
        },

        cat : {
            label : "Cat",
            pal   : { k: k, o: c_o, w: c_w, p: c_p, g: c_g },
            hit   : [2, 1, 13, 19],
            map   : [
                "................",
                "...kk.....kk....",
                "..kpk.....kpk...",
                "..kok.....kok...",
                "..kooookkooook..",
                "..koooooooooook.",
                "..kogokkkkogok..",
                "..koooooppoook..",
                "..kkoowwwwookk..",
                "....kooooook....",
                "....kooooook....",
                "...koowwwwook...",
                "...kowwwwwwok.k.",
                "...kowwwwwwokkk.",
                "...kowwwwwwok.k.",
                "...kowwwwwwok...",
                "...koowwwwook...",
                "...kooooooook...",
                "...kokkkkkkok...",
                "...kkk....kkk..."
            ]
        },

        kid : {
            label : "Kid",
            pal   : { k: k, s: d_s, h: d_h, t: d_t, p: d_p, e: d_e, r: d_r },
            hit   : [3, 1, 12, 19],
            map   : [
                ".....kkkkkk.....",
                "....khhhhhhk....",
                "...khhhhhhhhk...",
                "...khhhhhhhhk...",
                "...khsssssshk...",
                "...ksessssesk...",
                "...ksssssssssk..",
                "...ksseeeeessk..",
                "....ksssssssk...",
                ".....kssssk.....",
                "...kkktttkkkk...",
                "..ksktttttttksk.",
                "..ksktttttttksk.",
                "..ksktttttttksk.",
                "..kkkttttttkkk..",
                "....kppppppk....",
                "....kppkkppk....",
                "....kppk.kppk...",
                "....kppk.kppk...",
                "...krrrk.krrrk.."
            ]
        },

        dino : {
            label : "Dino",
            pal   : { k: k, g: s_g, d: s_d, b: s_b, e: s_e },
            hit   : [1, 8, 14, 19],
            map   : [
                "..........kkkk..",
                ".........kggegk.",
                ".........kgggk..",
                "..........kgk...",
                "..........kgk...",
                ".........kgk....",
                ".........kgk....",
                "........kgk.....",
                "..kkk...kgk.....",
                ".kdddkkkggk.....",
                "kddggggggggkk...",
                "kdgggggggggggk..",
                ".kgbbbbbbbgggk..",
                ".kgbbbbbbbbbgk..",
                "..kggbbbbbggk...",
                "..kgkkggkkgggk..",
                "..kgk.kgk.kggk..",
                "..kgk.kgk.kgk...",
                "..kgk.kgk.kgk...",
                "..kkk.kkk.kkk..."
            ]
        }
    };
    return global.art_chars_cache;
}

/// @desc Ordered list of avatar keys, left to right on the character screen.
function art_char_order() {
    return ["robot", "cat", "kid", "dino"];
}
