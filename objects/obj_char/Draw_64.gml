ui_begin();
var C     = ui_colours();
var mx    = ui_mx();
var my    = ui_my();
var chars = art_chars();
var order = art_char_order();

draw_backdrop(false);

draw_txt_shadow(SCR_W * 0.5, 70, "Pick who you want to be", 4, C.gold, fa_center, fa_top);

for (var i = 0; i < array_length(order); i++) {
    var key = order[i];
    var a   = chars[$ key];
    var r   = card_rect(i);
    var hot = hit_rect(mx, my, r);
    var on  = (sel == key);
    if (hot) ui_hand();

    draw_set_colour(on ? C.gold : C.ink);
    draw_rectangle(r[0] - 5, r[1] - 5, r[2] + 5, r[3] + 5, false);
    draw_set_colour(hot || on ? C.panel : C.panel_lo);
    draw_rectangle(r[0], r[1], r[2], r[3], false);

    // every avatar is drawn on the same size canvas, in the same spot
    var ax = (r[0] + r[2]) * 0.5;
    var ay = r[1] + 46;
    var hop = (hot || on) ? -abs(sin(t * 0.08 + i)) * 8 : 0;
    draw_pixel_map(a.map, a.pal, ax - CHAR_W * 0.5, ay + hop, CHAR_SCALE);

    draw_txt(ax, r[3] - 54, a.label, 3, C.ink, fa_center, fa_top);
    if (on) {
        // a green badge pops onto the card you picked
        var pp = ease_out_back(min(1, sel_t / 14));
        draw_set_colour(C.ink);
        draw_circle(r[2] - 6, r[1] + 6, 22 * pp + 3, false);
        draw_set_colour(C.good);
        draw_circle(r[2] - 6, r[1] + 6, 22 * pp, false);
        if (pp > 0.3) draw_tick(r[2] - 6, r[1] + 6, 26 * pp, C.white);
        draw_txt(ax, r[3] - 22, "Picked!", 2, C.good, fa_center, fa_top, 1, true);
    }
}

// ---- the name box ----
if (naming) {
    var p1 = SCR_W * 0.5 - 380, p2 = SCR_W * 0.5 + 380;
    var q1 = 526, q2 = 614;
    draw_panel(p1, q1, p2, q2);
    draw_txt(p1 + 24, (q1 + q2) * 0.5, "What is your name?", 3, C.ink, fa_left, fa_middle);

    var f1 = p1 + 400, f2 = p2 - 24, g1 = q1 + 16, g2 = q2 - 16;
    draw_set_colour(C.ink);
    draw_rectangle(f1 - 3, g1 - 3, f2 + 3, g2 + 3, false);
    draw_set_colour(C.white);
    draw_rectangle(f1, g1, f2, g2, false);
    draw_txt(f1 + 12, (g1 + g2) * 0.5, typed, 3, C.ink, fa_left, fa_middle);
    if ((current_time div 400) % 2 == 0) {
        var caret = f1 + 14 + txt_w(typed, 3);
        draw_set_colour(C.ink);
        draw_rectangle(caret, g1 + 8, caret + 4, g2 - 8, false);
    }

    var ready = (str_trim(typed) != "");
    var ghot  = hit_rect(mx, my, rect_start) && ready;
    if (ready) draw_glow_rect(rect_start, t, C.gold);        // "press this next"
    draw_text_button(rect_start[0], rect_start[1], rect_start[2], rect_start[3],
                     ready ? "Let's go" : "Type your name", ready ? 3 : 2, ghot,
                     ready ? C.gold : C.panel_lo);
} else {
    draw_txt(SCR_W * 0.5, 560, "Tap one of them.", 3, C.panel, fa_center, fa_top);
}

draw_back_button(mx, my, "Back");
ui_end();
