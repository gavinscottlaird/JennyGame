/// scr_draw -- shared drawing helpers: pixel art, text, panels, buttons.

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

/// @desc Text at a whole-number scale of the pixel font.
function draw_txt(px, py, txt, sc, col, ha = fa_left, va = fa_top, alpha = 1) {
    draw_set_font(fnt_pix);
    draw_set_halign(ha);
    draw_set_valign(va);
    draw_set_colour(col);
    draw_set_alpha(alpha);
    draw_text_transformed(px, py, txt, sc, sc, 0);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @desc Text with a soft drop shadow, for headings on dark backgrounds.
function draw_txt_shadow(px, py, txt, sc, col, ha = fa_left, va = fa_top) {
    var C = ui_colours();
    draw_txt(px + sc, py + sc, txt, sc, C.shade, ha, va, 0.35);
    draw_txt(px, py, txt, sc, col, ha, va);
}

/// @desc Width of text drawn with draw_txt at that scale.
function txt_w(txt, sc) {
    draw_set_font(fnt_pix);
    return string_width(txt) * sc;
}

/// @desc Height of text drawn with draw_txt at that scale.
function txt_h(txt, sc) {
    draw_set_font(fnt_pix);
    return string_height(txt) * sc;
}

/// @desc Text that wraps inside a given width.
function draw_txt_wrap(px, py, txt, sc, col, wide, ha = fa_center, va = fa_top) {
    draw_set_font(fnt_pix);
    draw_set_halign(ha);
    draw_set_valign(va);
    draw_set_colour(col);
    draw_set_alpha(1);
    draw_text_ext_transformed(px, py, txt, string_height("M") + 4, wide / sc, sc, sc, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @desc How tall wrapped text will be.
function txt_wrap_h(txt, sc, wide) {
    draw_set_font(fnt_pix);
    return string_height_ext(txt, string_height("M") + 4, wide / sc) * sc;
}

/// @desc Bright colour number `n` for confetti.
function confetti_colour(n) {
    var C = ui_colours();
    var list = [C.gold, C.good, C.cool, C.bad, C.white];
    return list[n % array_length(list)];
}

/// @desc The background used by every screen: night sky, stars, floor.
/// @param {Bool} [with_floor]
function draw_backdrop(with_floor = true) {
    var C = ui_colours();
    draw_set_alpha(1);
    draw_set_colour(C.sky);
    draw_rectangle(0, 0, SCR_W, SCR_H, false);

    // wall
    draw_set_colour(C.wall);
    draw_rectangle(0, 0, SCR_W, with_floor ? FLOOR_Y + 18 : SCR_H, false);

    // simple pixel wallpaper: a dot grid
    draw_set_colour(C.wall_lo);
    for (var yy = 40; yy < (with_floor ? FLOOR_Y : SCR_H); yy += 48) {
        for (var xx = 30; xx < SCR_W; xx += 48) {
            draw_rectangle(xx, yy, xx + 5, yy + 5, false);
        }
    }

    if (with_floor) {
        draw_set_colour(C.floor);
        draw_rectangle(0, FLOOR_Y + 18, SCR_W, SCR_H, false);
        draw_set_colour(C.floor_lo);
        for (var xx = 0; xx < SCR_W; xx += 64) {
            draw_rectangle(xx, FLOOR_Y + 18, xx + 3, SCR_H, false);
        }
        draw_rectangle(0, FLOOR_Y + 18, SCR_W, FLOOR_Y + 22, false);
    }
}

/// @desc Cuts text down until it fits the width, adding dots.
function txt_fit(txt, sc, wide) {
    if (txt_w(txt, sc) <= wide) return txt;
    var s = txt;
    while (string_length(s) > 1 && txt_w(s + "...", sc) > wide) {
        s = string_copy(s, 1, string_length(s) - 1);
    }
    return s + "...";
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
function draw_text_button(x1, y1, x2, y2, txt, sc, hot, fill = -1) {
    var C = ui_colours();
    if (fill == -1) fill = C.gold;
    var lift = hot ? 3 : 0;
    draw_set_colour(C.ink);
    draw_rectangle(x1 - 4, y1 - 4 - lift, x2 + 4, y2 + 4, false);
    draw_set_colour(hot ? C.gold : fill);
    draw_rectangle(x1, y1 - lift, x2, y2, false);
    draw_set_colour(C.gold_dark);
    draw_rectangle(x1, y2 - 6, x2, y2, false);
    draw_txt((x1 + x2) * 0.5, (y1 + y2) * 0.5 - lift, txt, sc, C.ink, fa_center, fa_middle);
    return hot;
}

/// @desc True when the mouse (GUI space) is inside the rectangle.
function hit_rect(mx, my, r) {
    return (mx >= r[0] && mx <= r[2] && my >= r[1] && my <= r[3]);
}

/// @desc True when the mouse (GUI space) is inside the circle.
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
    draw_set_alpha(1);
    draw_set_colour(C.ink);
    draw_rectangle(r[0] - 3, r[1] - 3, r[2] + 3, r[3] + 3, false);
    draw_set_colour(hot ? C.gold : C.wall);
    draw_rectangle(r[0], r[1], r[2], r[3], false);
    draw_set_colour(hot ? C.ink : C.white);
    draw_triangle(r[0] + 32, r[1] + 12, r[0] + 32, r[3] - 12, r[0] + 14, (r[1] + r[3]) * 0.5, false);
    draw_rectangle(r[0] + 30, r[1] + 22, r[2] - 10, r[3] - 22, false);
    if (hot && label != "") draw_txt(r[0], r[1] - 26, label, 2, C.white, fa_left, fa_top);
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
function draw_action_button(cx, cy, art, hot, count, enabled) {
    var C = ui_colours();
    var r = BTN_R + (hot && enabled ? 3 : 0);

    // shadow + rim
    draw_set_alpha(0.25);
    draw_set_colour(C.shade);
    draw_circle(cx + 2, cy + 4, r, false);
    draw_set_alpha(1);
    draw_set_colour(C.ink);
    draw_circle(cx, cy, r + 3, false);
    draw_set_colour(enabled ? C.gold : C.panel_lo);
    draw_circle(cx, cy, r, false);
    draw_set_colour(C.gold_dark);
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
        draw_circle(cx + r - 6, cy - r + 6, 12, false);
        draw_set_colour(C.ink);
        draw_circle(cx + r - 6, cy - r + 6, 12, true);
        draw_txt(cx + r - 6, cy - r + 6, "x" + string(count), 1, C.white, fa_center, fa_middle);
    }

    // tooltip below on hover
    if (hot) {
        var sc = 2;
        var tw = txt_w(art.label, sc);
        var tx = cx, ty = cy + r + 10;
        draw_set_colour(C.ink);
        draw_rectangle(tx - tw * 0.5 - 8, ty, tx + tw * 0.5 + 8, ty + 24, false);
        draw_txt(tx, ty + 12, art.label, sc, C.white, fa_center, fa_middle);
    }
}
