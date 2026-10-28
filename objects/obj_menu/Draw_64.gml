ui_begin();
var C  = ui_colours();
var mx = ui_mx();
var my = ui_my();

draw_backdrop(false);

draw_txt_shadow(SCR_W * 0.5, 92, "Pixel Problem Solver", 6, C.gold, fa_center, fa_top);
draw_txt(SCR_W * 0.5, 172, "Make a plan. Guess what happens. See what really happens.",
         2, C.panel, fa_center, fa_top);

// the four helpers, waving hello
var chars = art_chars();
var order = art_char_order();
for (var i = 0; i < array_length(order); i++) {
    var a  = chars[$ order[i]];
    var ax = SCR_W * 0.5 + (i - 1.5) * 150;
    var ay = 400 - abs(sin(t * 0.04 + i * 0.8)) * 18;
    draw_set_alpha(0.2);
    draw_set_colour(C.shade);
    draw_rectangle(ax - 30, 402, ax + 30, 410, false);
    draw_set_alpha(1);
    draw_pixel_map(a.map, a.pal, ax - CHAR_W * 0.5, ay - CHAR_H, CHAR_SCALE);
}

var php = hit_rect(mx, my, rect_play);
draw_glow_rect(rect_play, t, C.gold);              // "start here"
draw_text_button(rect_play[0], rect_play[1], rect_play[2], rect_play[3], "Play", 4, php);

var shp = hit_rect(mx, my, rect_score);
draw_text_button(rect_score[0], rect_score[1], rect_score[2], rect_score[3],
                 "See my score", 2, shp, C.panel);

// which copy of the game this is (see GAME_VERSION in scr_config), and the
// window size, so a tester can tell Claude exactly what they are seeing
draw_txt(24, 14, GAME_VERSION, 2, C.cool);
var U = global.ui;
draw_txt(24, 44, "Window: " + string(U.ww) + " x " + string(U.wh)
         + (window_get_fullscreen() ? " (full screen)" : "")
         + (U.fonts_ok ? "" : "   -   backup font (font files not found)"),
         1, U.fonts_ok ? C.panel_lo : C.bad);

draw_txt(SCR_W * 0.5, SCR_H - 64, "Full screen: press F11, or the button in the top corner.",
         1, C.panel_lo, fa_center, fa_top);
draw_txt(SCR_W * 0.5, SCR_H - 38, "Use the arrow keys or A W S D to walk.",
         1, C.panel_lo, fa_center, fa_top);

ui_end();
