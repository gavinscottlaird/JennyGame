/// scr_screen -- keeps everything sharp at any window size, and full screen.
///
/// WHY THINGS ARE SHARP NOW (Jenny, Oct 2026: "everything is blurry")
/// The old version drew all text with one tiny font (Arial, size 8) blown up
/// 2 to 6 times, so the soft edges of every letter were blown up too.
///
/// Now:
/// * All the layout code still works in one fixed "design" size,
///   SCR_W x SCR_H (1366 x 768), so no screen had to be laid out again.
/// * The GUI layer is set to the REAL size of the window (or the whole screen
///   in full screen). A scale and an offset map design units onto real pixels,
///   so shapes and pixel art are drawn at full resolution.
/// * Each text size gets its own font, made from a real font file at the
///   exact pixel size it appears on screen, and drawn 1:1, never stretched.
///   When the window changes size the fonts are made again for the new size.
/// * The whole window is painted, so odd screen shapes get no empty bars.
///
/// Full screen: the corner button on every screen, or F11.
///
/// Safety net: if the font files cannot be loaded, the old font is used, so
/// text always shows. The title screen's version line then says "backup font".
///
/// The font is Atkinson Hyperlegible (Braille Institute), made to be easy to
/// read; it is free to share under the SIL Open Font License, which ships
/// with the game in datafiles/AtkinsonHyperlegible-OFL.txt.

#macro FONT_FILE_REG  "AtkinsonHyperlegible-Regular.ttf"
#macro FONT_FILE_BOLD "AtkinsonHyperlegible-Bold.ttf"
#macro FONT_LINE_H    1.24      // this font's line height, as a share of its size

/// @desc Sets up the screen once. Called from game_init.
function ui_setup() {
    if (variable_global_exists("ui")) return;
    global.ui = {
        ww : 0, wh : 0,           // real window size, in pixels
        s  : 1,                   // real pixels per design unit
        ox : 0, oy : 0,           // where the design area starts in the window
        fonts    : {},            // "r22" / "b32" -> font made for this window size
        fonts_ok : true,          // false = font files missing, using fnt_pix
        m_ui  : matrix_build_identity(),
        m_id  : matrix_build_identity(),
        m_cur : matrix_build_identity(),
        frame : 0,
        hand  : false,            // something clickable is under the mouse
        sized : false,            // the window was fitted to the screen at start
        center_at : 0,
        pend_w : 0, pend_h : 0,   // a new window size, waiting to settle
        pend_t : 0
    };
    draw_set_circle_precision(64);  // round buttons stay round when big
    gpu_set_tex_filter(false);      // text is drawn 1:1, so no smoothing needed
    draw_set_font(fnt_pix);
    ui_refresh();
}

/// @desc Re-measures the window. When it changed size, works out the new
///       scale and throws the old fonts away (they are made again on use).
function ui_refresh() {
    var U  = global.ui;
    var ww = window_get_width();
    var wh = window_get_height();
    if (ww <= 0 || wh <= 0) return;            // minimised
    if (ww == U.ww && wh == U.wh) { U.pend_t = 0; return; }
    // While the window is being dragged to a new size, wait until it stops
    // (a tenth of a second) before making new fonts, so resizing stays smooth.
    if (U.ww > 0) {
        if (ww != U.pend_w || wh != U.pend_h) {
            U.pend_w = ww;
            U.pend_h = wh;
            U.pend_t = 0;
            return;
        }
        U.pend_t++;
        if (U.pend_t < 6) return;
    }
    U.pend_t = 0;
    U.ww = ww;
    U.wh = wh;
    display_set_gui_size(ww, wh);              // one GUI pixel = one real pixel

    var s = min(ww / SCR_W, wh / SCR_H);
    // When it costs almost nothing, snap the scale so every art pixel
    // (5 design units) covers a whole number of screen pixels.
    var snap = floor(s * 5) / 5;
    if (snap > 0 && snap >= s * 0.94) s = snap;
    U.s  = s;
    U.ox = round((ww - SCR_W * s) * 0.5);
    U.oy = round((wh - SCR_H * s) * 0.5);
    U.m_ui = matrix_build(U.ox, U.oy, 0, 0, 0, 0, s, s, 1);
    ui_fonts_clear();
}

/// @desc Deletes every font made for the old window size.
function ui_fonts_clear() {
    var U = global.ui;
    draw_set_font(fnt_pix);
    var names = variable_struct_get_names(U.fonts);
    for (var i = 0; i < array_length(names); i++) {
        var f = U.fonts[$ names[i]];
        if (f != fnt_pix && font_exists(f)) font_delete(f);
    }
    U.fonts = {};
}

/// @desc Text size in design pixels for the old "times bigger" numbers the
///       screens use (1 = small help text ... 6 = the title).
function ui_px(sc) {
    if (sc <= 1)   return 17;
    if (sc <= 1.5) return 19;
    if (sc <= 2)   return 22;
    if (sc <= 2.5) return 27;
    if (sc <= 3)   return 32;
    if (sc <= 4)   return 43;
    if (sc <= 5)   return 54;
    return 64;
}

/// @desc The font for this text size, made at the exact size it shows on
///       screen. Returns fnt_pix if the font files could not be loaded.
function ui_font(sc, bold) {
    var U = global.ui;
    if (!U.fonts_ok) return fnt_pix;
    var px  = ui_px(sc);
    var key = (bold ? "b" : "r") + string(px);
    if (variable_struct_exists(U.fonts, key)) return U.fonts[$ key];

    var file = bold ? FONT_FILE_BOLD : FONT_FILE_REG;
    var want = max(6, round(px * U.s));          // size on screen, in real pixels
    var f    = font_add(file, want, false, false, 32, 128);
    if (f == -1 || !font_exists(f)) {
        U.fonts_ok = false;
        show_debug_message("scr_screen: could not load " + file + "; using fnt_pix");
        return fnt_pix;
    }
    // The manual is not clear whether font_add's size is pixels or points.
    // Measure it, and make it once more at the right size if it came out wrong.
    draw_set_font(f);
    var lh     = string_height("M");
    var target = want * FONT_LINE_H;
    if (lh > 0 && abs(lh - target) > target * 0.15) {
        draw_set_font(fnt_pix);
        font_delete(f);
        f = font_add(file, max(6, round(want * target / lh)), false, false, 32, 128);
        if (f == -1 || !font_exists(f)) {
            U.fonts_ok = false;
            return fnt_pix;
        }
    }
    U.fonts[$ key] = f;
    return f;
}

/// @desc Start of every Draw GUI event: fits the window, handles full
///       screen, paints the whole window, then switches to design units.
function ui_begin() {
    var U = global.ui;
    ui_refresh();
    U.frame++;
    U.hand = false;

    // At the start, make the window as big as fits the screen comfortably.
    // More real pixels = sharper. Only once per run, never in full screen.
    if (!U.sized && U.frame >= 2) {
        U.sized = true;
        if (!window_get_fullscreen()) {
            var dw = display_get_width();
            var dh = display_get_height();
            var steps = [1.4, 1.2, 1.0, 0.8, 0.6];
            for (var i = 0; i < array_length(steps); i++) {
                var w = round(SCR_W * steps[i]);
                var h = round(SCR_H * steps[i]);
                if (w <= dw * 0.92 && h <= dh * 0.86) {
                    if (w != window_get_width() || h != window_get_height()) {
                        window_set_size(w, h);
                        U.center_at = U.frame + 2;     // centre once the new size lands
                    }
                    break;
                }
            }
        }
    }
    if (U.center_at > 0 && U.frame >= U.center_at) {
        U.center_at = 0;
        window_center();
    }

    // full screen: F11, or the button in the top-right corner
    if (keyboard_check_pressed(vk_f11)) ui_toggle_fullscreen();
    if (mouse_check_button_pressed(mb_left) && ui_over_fs()) ui_toggle_fullscreen();

    matrix_set(matrix_world, U.m_id);
    draw_set_alpha(1);
    draw_set_colour(ui_colours().sky);
    draw_rectangle(0, 0, U.ww, U.wh, false);
    U.m_cur = U.m_ui;
    matrix_set(matrix_world, U.m_ui);
}

/// @desc End of every Draw GUI event: the full-screen button, the mouse
///       pointer (a hand over anything you can click), and back to normal.
function ui_end() {
    var U = global.ui;
    ui_draw_fs_button();
    matrix_set(matrix_world, U.m_id);
    U.m_cur = U.m_id;
    window_set_cursor(U.hand ? cr_handpoint : cr_default);
}

/// @desc Marks that the mouse is over something clickable (hand pointer).
function ui_hand() {
    global.ui.hand = true;
}

/// @desc Mouse position in design units.
function ui_mx() {
    var U = global.ui;
    return (window_mouse_get_x() - U.ox) / U.s;
}
function ui_my() {
    var U = global.ui;
    return (window_mouse_get_y() - U.oy) / U.s;
}

/// @desc A left click this step that is not on the full-screen button.
function ui_click() {
    return mouse_check_button_pressed(mb_left) && !ui_over_fs();
}

/// @desc Edges of the whole window, in design units. Backgrounds and bars
///       stretch to these so nothing is left unpainted on any screen shape.
function ui_left()   { var U = global.ui; return -U.ox / U.s - 1; }
function ui_right()  { var U = global.ui; return (U.ww - U.ox) / U.s + 1; }
function ui_top()    { var U = global.ui; return -U.oy / U.s - 1; }
function ui_bottom() { var U = global.ui; return (U.wh - U.oy) / U.s + 1; }

/// @desc Switches between a window and full screen.
function ui_toggle_fullscreen() {
    window_set_fullscreen(!window_get_fullscreen());
}

/// @desc True while the mouse is over the full-screen button.
function ui_over_fs() {
    return hit_rect(ui_mx(), ui_my(), rect_fs());
}

/// @desc The small full-screen button in the top-right corner.
function ui_draw_fs_button() {
    var C   = ui_colours();
    var r   = rect_fs();
    var hot = ui_over_fs();
    var fs  = window_get_fullscreen();
    if (hot) ui_hand();

    draw_set_alpha(1);
    draw_set_colour(C.ink);
    draw_rectangle(r[0] - 3, r[1] - 3, r[2] + 3, r[3] + 3, false);
    draw_set_colour(hot ? C.gold : C.wall);
    draw_rectangle(r[0], r[1], r[2], r[3], false);

    // four corner marks: pointing out (make it big) or in (make it small)
    var cx = (r[0] + r[2]) * 0.5;
    var cy = (r[1] + r[3]) * 0.5;
    var L  = 6, w = 3;
    draw_set_colour(hot ? C.ink : C.white);
    for (var sx = -1; sx <= 1; sx += 2) {
        for (var sy = -1; sy <= 1; sy += 2) {
            var px = cx + sx * (fs ? 4 : 11);
            var py = cy + sy * (fs ? 3 : 9);
            var dx = fs ? sx : -sx;        // which way the short arms run
            var dy = fs ? sy : -sy;
            draw_rectangle(min(px, px + dx * L), py - (w - 1) * 0.5,
                           max(px, px + dx * L), py + (w - 1) * 0.5, false);
            draw_rectangle(px - (w - 1) * 0.5, min(py, py + dy * L),
                           px + (w - 1) * 0.5, max(py, py + dy * L), false);
        }
    }

    if (hot) {
        var tip = fs ? "Leave full screen (F11)" : "Full screen (F11)";
        var tw  = txt_w(tip, 1);
        var tx2 = r[0] - 10;
        draw_set_colour(C.ink);
        draw_rectangle(tx2 - tw - 16, r[1], tx2, r[3], false);
        draw_txt(tx2 - 8, (r[1] + r[3]) * 0.5, tip, 1, C.white, fa_right, fa_middle);
    }
}
