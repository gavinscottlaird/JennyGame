/// scr_draw -- shared drawing helpers: pixel art, text, panels, buttons,
///             and the little helpers (arrows, ticks, glows) that show the
///             player what just happened and what to do next.
///
/// Everything here works in design units (SCR_W x SCR_H). scr_screen maps
/// that onto the real window, and draws text 1:1 so it is never blurry.

/// @desc Draws one ASCII pixel map. "." pixels are skipped.
///       Runs of the same colour are merged into a single rectangle so a full
///       room of art still costs only a handful of draw calls.
/// @param {Array} map    array of equal-length strings
/// @param {Struct} pal   letter -> colour
/// @param {Real} px      left edge on screen
/// @param {Real} py      top edge on screen
/// @param {Real} sc      pixels per art pixel
/// @param {Real} [alpha]
/// @param {Bool} [flip_v] draw it upside down (used for the tumble gag)
function draw_pixel_map(map, pal, px, py, sc, alpha = 1, flip_v = false) {
    draw_set_alpha(alpha);
    var rows = array_length(map);
    for (var r = 0; r < rows; r++) {
        var line = map[flip_v ? (rows - 1 - r) : r];
        var len  = string_length(line);
        var c    = 0;
        while (c < len) {
            var ch = string_char_at(line, c + 1);
            if (ch == ".") { c++; continue; }
            var run = 1;
            while (c + run < len && string_char_at(line, c + run + 1) == ch) run++;
            if (variable_struct_exists(pal, ch)) {
                draw_set_colour(pal[$ ch]);
                draw_rectangle(px + c * sc, py + r * sc,
                               px + (c + run) * sc - 1, py + (r + 1) * sc - 1, false);
            }
            c += run;
        }
    }
    draw_set_alpha(1);
}

/// @desc Draws a pixel map as a flat one-colour silhouette (used for button icons).
function draw_pixel_silhouette(map, px, py, sc, col, alpha = 1) {
    draw_set_colour(col);
    draw_set_alpha(alpha);
    var rows = array_length(map);
    for (var r = 0; r < rows; r++) {
        var line = map[r];
        var len  = string_length(line);
        var c    = 0;
        while (c < len) {
            if (string_char_at(line, c + 1) == ".") { c++; continue; }
            var run = 1;
            while (c + run < len && string_char_at(line, c + run + 1) != ".") run++;
            draw_rectangle(px + c * sc, py + r * sc,
                           px + (c + run) * sc - 1, py + (r + 1) * sc - 1, false);
            c += run;
        }
    }
    draw_set_alpha(1);
}

// ------------------------------------------------------------------ text
// `sc` is the text size: 1 = small help text, 2 = normal, 3 = big,
// 4 = heading, 6 = title (see ui_px in scr_screen for the pixel sizes).
// `bold` -1 means "bold when big" (size 3 and up).

/// @desc True when this text should be bold.
function txt_bold(sc, bold) {
    return (bold == -1) ? (sc >= 3) : bold;
}

/// @desc Text at one of the game's sizes. Sharp at any window size.
function draw_txt(px, py, txt, sc, col, ha = fa_left, va = fa_top, alpha = 1, bold = -1) {
    var U = global.ui;
    draw_set_halign(ha);
    draw_set_valign(va);
    draw_set_colour(col);
    draw_set_alpha(alpha);
    var f = ui_font(sc, txt_bold(sc, bold));
    if (U.fonts_ok) {
        // drawn in real screen pixels, at whole-pixel positions, 1:1
        draw_set_font(f);
        matrix_set(matrix_world, U.m_id);
        draw_text(round(U.ox + px * U.s), round(U.oy + py * U.s), txt);
        matrix_set(matrix_world, U.m_cur);
    } else {
        draw_set_font(fnt_pix);                       // backup font
        draw_text_transformed(px, py, txt, sc, sc, 0);
    }
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @desc Text with a soft drop shadow, for headings on dark backgrounds.
function draw_txt_shadow(px, py, txt, sc, col, ha = fa_left, va = fa_top) {
    var C = ui_colours();
    var d = max(2, sc);
    draw_txt(px + d, py + d, txt, sc, C.shade, ha, va, 0.35);
    draw_txt(px, py, txt, sc, col, ha, va);
}

/// @desc Width of text drawn with draw_txt at that size, in design units.
function txt_w(txt, sc, bold = -1) {
    var U = global.ui;
    var f = ui_font(sc, txt_bold(sc, bold));
    if (U.fonts_ok) {
        draw_set_font(f);
        return string_width(txt) / U.s;
    }
    draw_set_font(fnt_pix);
    return string_width(txt) * sc;
}

/// @desc Height of text drawn with draw_txt at that size, in design units.
function txt_h(txt, sc, bold = -1) {
    var U = global.ui;
    var f = ui_font(sc, txt_bold(sc, bold));
    if (U.fonts_ok) {
        draw_set_font(f);
        return string_height(txt) / U.s;
    }
    draw_set_font(fnt_pix);
    return string_height(txt) * sc;
}

/// @desc Text that wraps inside a given width.
function draw_txt_wrap(px, py, txt, sc, col, wide, ha = fa_center, va = fa_top, bold = -1) {
    var U = global.ui;
    draw_set_halign(ha);
    draw_set_valign(va);
    draw_set_colour(col);
    draw_set_alpha(1);
    var f = ui_font(sc, txt_bold(sc, bold));
    if (U.fonts_ok) {
        draw_set_font(f);
        var sep = string_height("M") + round(2 * U.s);
        matrix_set(matrix_world, U.m_id);
        draw_text_ext(round(U.ox + px * U.s), round(U.oy + py * U.s), txt, sep, wide * U.s);
        matrix_set(matrix_world, U.m_cur);
    } else {
        draw_set_font(fnt_pix);
        draw_text_ext_transformed(px, py, txt, string_height("M") + 4, wide / sc, sc, sc, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @desc How tall wrapped text will be, in design units.
function txt_wrap_h(txt, sc, wide, bold = -1) {
    var U = global.ui;
    var f = ui_font(sc, txt_bold(sc, bold));
    if (U.fonts_ok) {
        draw_set_font(f);
        var sep = string_height("M") + round(2 * U.s);
        return string_height_ext(txt, sep, wide * U.s) / U.s;
    }
    draw_set_font(fnt_pix);
    return string_height_ext(txt, string_height("M") + 4, wide / sc) * sc;
}

/// @desc Cuts text down until it fits the width, adding dots.
function txt_fit(txt, sc, wide, bold = -1) {
    if (txt_w(txt, sc, bold) <= wide) return txt;
    var s = txt;
    while (string_length(s) > 1 && txt_w(s + "...", sc, bold) > wide) {
        s = string_copy(s, 1, string_length(s) - 1);
    }
    return s + "...";
}

/// @desc Bright colour number `n` for confetti.
function confetti_colour(n) {
    var C = ui_colours();
    var list = [C.gold, C.good, C.cool, C.bad, C.white];
    return list[n % array_length(list)];
}

/// @desc The background used by every screen: night sky, wall, floor.
///       It fills the whole window, whatever its shape.
/// @param {Bool} [with_floor]
function draw_backdrop(with_floor = true) {
    var C  = ui_colours();
    var L  = ui_left(), R = ui_right(), T = ui_top(), B = ui_bottom();
    draw_set_alpha(1);
    draw_set_colour(C.sky);
    draw_rectangle(L, T, R, B, false);

    // wall
    draw_set_colour(C.wall);
    draw_rectangle(L, T, R, with_floor ? FLOOR_Y + 18 : B, false);

    // simple pixel wallpaper: a dot grid, lined up with the design area
    draw_set_colour(C.wall_lo);
    var x0 = 30 + 48 * floor((L - 30) / 48);
    var y0 = 40 + 48 * floor((T - 40) / 48);
    for (var yy = y0; yy < (with_floor ? FLOOR_Y : B); yy += 48) {
        for (var xx = x0; xx < R; xx += 48) {
            draw_rectangle(xx, yy, xx + 5, yy + 5, false);
        }
    }

    if (with_floor) {
        draw_set_colour(C.floor);
        draw_rectangle(L, FLOOR_Y + 18, R, B, false);
        draw_set_colour(C.floor_lo);
        var f0 = 64 * floor(L / 64);
        for (var xx = f0; xx < R; xx += 64) {
            draw_rectangle(xx, FLOOR_Y + 18, xx + 3, B, false);
        }
        draw_rectangle(L, FLOOR_Y + 18, R, FLOOR_Y + 22, false);
    }
}

/// @desc A dark see-through band across the whole window width.
function draw_band(y1, y2, col, alpha) {
    draw_set_alpha(alpha);
    draw_set_colour(col);
    draw_rectangle(ui_left(), y1, ui_right(), y2, false);
    draw_set_alpha(1);
}

/// @desc A cream card with a thick pixel border.
function draw_panel(x1, y1, x2, y2, fill = -1, border = -1) {
    var C = ui_colours();
    if (fill   == -1) fill   = C.panel;
    if (border == -1) border = C.ink;
    draw_set_alpha(1);
    draw_set_colour(border);
    draw_rectangle(x1 - 4, y1 - 4, x2 + 4, y2 + 4, false);
    draw_set_colour(fill);
    draw_rectangle(x1, y1, x2, y2, false);
}

/// @desc Rectangle button with a word on it. Returns true while hovered.
///       It sinks a little while the mouse button is held down on it.
function draw_text_button(x1, y1, x2, y2, txt, sc, hot, fill = -1) {
    var C = ui_colours();
    if (fill == -1) fill = C.gold;
    if (hot) ui_hand();
    var lift = hot ? 3 : 0;
    if (hot && mouse_check_button(mb_left)) lift = -2;       // pressed in
    draw_set_colour(C.ink);
    draw_rectangle(x1 - 4, y1 - 4 - lift, x2 + 4, y2 + 4, false);
    draw_set_colour(hot ? C.gold : fill);
    draw_rectangle(x1, y1 - lift, x2, y2, false);
    draw_set_colour(C.gold_dark);
    draw_rectangle(x1, y2 - 6, x2, y2, false);
    draw_txt((x1 + x2) * 0.5, (y1 + y2) * 0.5 - lift - 2, txt, sc, C.ink, fa_center, fa_middle, 1, true);
    return hot;
}

/// @desc True when the mouse (design units) is inside the rectangle.
function hit_rect(mx, my, r) {
    return (mx >= r[0] && mx <= r[2] && my >= r[1] && my <= r[3]);
}

/// @desc True when the mouse (design units) is inside the circle.
function hit_circle(mx, my, cx, cy, r) {
    return (point_distance(mx, my, cx, cy) <= r);
}

/// @desc The small square arrow button in the bottom-left corner.
///       Spec: always visible. On the playing screen it ends the session,
///       everywhere else it steps back. Returns true while hovered.
function draw_back_button(mx, my, label) {
    var C   = ui_colours();
    var r   = rect_end();
    var hot = hit_rect(mx, my, r);
    if (hot) ui_hand();
    draw_set_alpha(1);
    draw_set_colour(C.ink);
    draw_rectangle(r[0] - 3, r[1] - 3, r[2] + 3, r[3] + 3, false);
    draw_set_colour(hot ? C.gold : C.wall);
    draw_rectangle(r[0], r[1], r[2], r[3], false);
    draw_set_colour(hot ? C.ink : C.white);
    draw_triangle(r[0] + 32, r[1] + 12, r[0] + 32, r[3] - 12, r[0] + 14, (r[1] + r[3]) * 0.5, false);
    draw_rectangle(r[0] + 30, r[1] + 22, r[2] - 10, r[3] - 22, false);
    if (hot && label != "") {
        var tw = txt_w(label, 2, true);
        draw_set_colour(C.ink);
        draw_rectangle(r[0] - 3, r[1] - 40, r[0] + tw + 17, r[1] - 8, false);
        draw_txt(r[0] + 7, r[1] - 24, label, 2, C.white, fa_left, fa_middle, 1, true);
    }
    return hot;
}

/// @desc The round action button that floats above a room object.
///       Spec: 60px circle, #FFD700, white icon, tooltip underneath on hover.
/// @param {Real} cx        centre x
/// @param {Real} cy        centre y
/// @param {Struct} art     entry from art_objects()
/// @param {Bool} hot       mouse is over it
/// @param {Real} count     how many times it is already in the chain (0 = none)
/// @param {Bool} enabled
/// @param {String} tip      words shown on hover (defaults to the object's name)
/// @param {Bool} show_tip   false = no hover tooltip (the words are already shown)
/// @param {Real} order      its step number in the plan (0 = not in the plan)
/// @param {Real} glow       0..1, a soft pulsing ring that says "you can tap me"
function draw_action_button(cx, cy, art, hot, count, enabled, tip = "", show_tip = true, order = 0, glow = 0) {
    var C = ui_colours();
    var r = BTN_R + (hot && enabled ? 4 : 0);
    if (hot && enabled) ui_hand();

    if (glow > 0) draw_halo(cx, cy, BTN_R + 7, 3 + glow * 4, C.gold, 0.25 + glow * 0.5);

    // shadow + rim
    draw_set_alpha(0.25);
    draw_set_colour(C.shade);
    draw_circle(cx + 2, cy + 4, r, false);
    draw_set_alpha(1);
    draw_set_colour(C.ink);
    draw_circle(cx, cy, r + 3, false);
    draw_set_colour(enabled ? C.gold : C.panel_lo);
    draw_circle(cx, cy, r, false);
    draw_set_colour(enabled ? C.gold_dark : C.wall_lo);
    draw_circle(cx, cy + 3, r - 6, false);
    draw_set_colour(enabled ? C.gold : C.panel_lo);
    draw_circle(cx, cy, r - 6, false);

    // white icon: the object's own art, as a silhouette
    var isc = 2;
    draw_pixel_silhouette(art.map, cx - OBJ_GRID * isc * 0.5, cy - OBJ_GRID * isc * 0.5,
                          isc, C.white, enabled ? 1 : 0.6);

    // little counter when the same button was picked more than once
    if (count > 1) {
        draw_set_colour(C.bad);
        draw_circle(cx + r - 6, cy - r + 6, 15, false);
        draw_set_colour(C.ink);
        draw_circle(cx + r - 6, cy - r + 6, 15, true);
        draw_txt(cx + r - 6, cy - r + 5, "x" + string(count), 1, C.white, fa_center, fa_middle, 1, true);
    }

    // its step number in the plan, in a green badge
    if (order > 0) draw_num_badge(cx + r - 2, cy - r + 2, 15, order, C.good);

    // tooltip below on hover
    if (hot && show_tip) {
        var sc = 2;
        var words = (tip == "") ? art.label : tip;
        var tw = txt_w(words, sc);
        var tx = clamp(cx, tw * 0.5 + 16, SCR_W - tw * 0.5 - 16);   // keep long tips on screen
        var ty = cy + r + 10;
        draw_set_colour(C.ink);
        draw_rectangle(tx - tw * 0.5 - 8, ty, tx + tw * 0.5 + 8, ty + 30, false);
        draw_txt(tx, ty + 15, words, sc, C.white, fa_center, fa_middle);
    }
}

// ------------------------------------------------------------------ helpers
// The small pictures that show what just happened and where to look next.

/// @desc Smooth slow-down: 0..1 in, 0..1 out.
function ease_out_cubic(p) {
    p = clamp(p, 0, 1);
    return 1 - power(1 - p, 3);
}

/// @desc Overshoots a little, then settles: things "pop" in.
function ease_out_back(p) {
    p = clamp(p, 0, 1);
    var c1 = 1.70158, c3 = c1 + 1;
    return 1 + c3 * power(p - 1, 3) + c1 * power(p - 1, 2);
}

/// @desc A thick ring (used for bursts and glows).
function draw_halo(cx, cy, r, w, col, alpha) {
    draw_set_colour(col);
    draw_set_alpha(clamp(alpha, 0, 1));
    draw_primitive_begin(pr_trianglestrip);
    var n = 48;
    for (var i = 0; i <= n; i++) {
        var a  = (i / n) * 2 * pi;
        var ca = cos(a), sa = sin(a);
        draw_vertex(cx + ca * r,       cy + sa * r);
        draw_vertex(cx + ca * (r + w), cy + sa * (r + w));
    }
    draw_primitive_end();
    draw_set_alpha(1);
}

/// @desc A tick mark centred on (cx, cy).
function draw_tick(cx, cy, size, col) {
    var w = max(2, size * 0.2);
    draw_set_colour(col);
    draw_line_width(cx - size * 0.38, cy + size * 0.02, cx - size * 0.1, cy + size * 0.3, w);
    draw_line_width(cx - size * 0.13, cy + size * 0.3,  cx + size * 0.4, cy - size * 0.3, w);
}

/// @desc A cross mark centred on (cx, cy).
function draw_cross(cx, cy, size, col) {
    var w = max(2, size * 0.2);
    var h = size * 0.3;
    draw_set_colour(col);
    draw_line_width(cx - h, cy - h, cx + h, cy + h, w);
    draw_line_width(cx - h, cy + h, cx + h, cy - h, w);
}

/// @desc A solid triangle pointing "up", "down", "left" or "right".
///       (cx, cy) is the centre; the tip is `size` away from it.
function draw_pointer(cx, cy, size, dir, col, alpha = 1) {
    draw_set_colour(col);
    draw_set_alpha(alpha);
    var s = size, h = size * 0.9;
    switch (dir) {
        case "down":  draw_triangle(cx - h, cy - s, cx + h, cy - s, cx, cy + s, false); break;
        case "up":    draw_triangle(cx - h, cy + s, cx + h, cy + s, cx, cy - s, false); break;
        case "left":  draw_triangle(cx + s, cy - h, cx + s, cy + h, cx - s, cy, false); break;
        default:      draw_triangle(cx - s, cy - h, cx - s, cy + h, cx + s, cy, false); break;
    }
    draw_set_alpha(1);
}

/// @desc A round badge with a number in it.
function draw_num_badge(cx, cy, r, num, col) {
    var C = ui_colours();
    draw_set_colour(C.ink);
    draw_circle(cx, cy, r + 3, false);
    draw_set_colour(col);
    draw_circle(cx, cy, r, false);
    draw_txt(cx, cy - 1, string(num), 1, C.white, fa_center, fa_middle, 1, true);
}

/// @desc A soft pulsing glow around a rectangle: "press this next".
function draw_glow_rect(r, t, col) {
    var p = 0.5 + 0.5 * sin(t * 0.12);
    var g = 6 + p * 6;
    draw_set_colour(col);
    draw_set_alpha(0.18 + p * 0.3);
    draw_rectangle(r[0] - 4 - g, r[1] - 4 - g, r[2] + 4 + g, r[3] + 4 + g, false);
    draw_set_alpha(1);
}
