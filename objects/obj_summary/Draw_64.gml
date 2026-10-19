var C  = ui_colours();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

draw_backdrop(false);

var rec = shown_record();

draw_txt_shadow(40, 24, "Your score", 4, C.gold, fa_left, fa_top);

if (rec == undefined) {
    draw_txt(SCR_W * 0.5, 320, "Nobody has played yet.", 3, C.panel, fa_center, fa_top);
} else {
    // ---------------- who, and how much XP ----------------
    var chars = art_chars();
    var akey  = variable_struct_exists(chars, rec.avatar) ? rec.avatar : "robot";
    var a     = chars[$ akey];

    draw_panel(40, 96, SCR_W - 170, 276);
    draw_pixel_map(a.map, a.pal, 70, 112, 3.4);

    draw_txt(200, 120, rec.name, 4, C.ink, fa_left, fa_top);
    draw_txt(200, 170, "Tries: " + string(rec.plays), 2, C.wall, fa_left, fa_top);
    draw_txt(200, 200, "Today: " + string(global.cur.session_xp) + " XP in "
                     + string(global.cur.session_n) + " tries", 2, C.wall, fa_left, fa_top);

    draw_set_colour(C.gold);
    draw_rectangle(SCR_W - 560, 116, SCR_W - 200, 256, false);
    draw_set_colour(C.ink);
    draw_rectangle(SCR_W - 560, 116, SCR_W - 200, 256, true);
    draw_txt(SCR_W - 380, 132, "TOTAL XP", 2, C.ink, fa_center, fa_top);
    draw_txt(SCR_W - 380, 196, string(rec.xp), 6, C.ink, fa_center, fa_middle);

    // switch between players
    if (array_length(names) > 1) {
        var ph = hit_rect(mx, my, rect_prev);
        var nh = hit_rect(mx, my, rect_next);
        draw_text_button(rect_prev[0], rect_prev[1], rect_prev[2], rect_prev[3], "<", 3, ph, C.panel);
        draw_text_button(rect_next[0], rect_next[1], rect_next[2], rect_next[3], ">", 3, nh, C.panel);
        draw_txt(SCR_W - 93, 160, string(idx + 1) + " of " + string(array_length(names)),
                 1, C.panel_lo, fa_center, fa_top);
    }

    // ---------------- the log ----------------
    var n = array_length(rec.entries);
    if (n == 0) {
        draw_txt(SCR_W * 0.5, 400, "No tries yet.", 3, C.panel, fa_center, fa_top);
    } else {
        for (var i = 0; i < n; i++) {
            var e  = rec.entries[n - 1 - i];         // newest first
            var ey = list_top + i * ENTRY_H - scroll;
            if (ey > list_bot || ey + ENTRY_H < list_top) continue;   // off screen

            var x1 = 40, x2 = SCR_W - 40;
            draw_panel(x1, ey, x2, ey + ENTRY_H - 10,
                       (i % 2 == 0) ? C.panel : C.panel_lo);

            draw_txt(x1 + 16, ey + 10, "#" + string(n - i) + "  " + e.when, 1, C.wall);
            draw_txt(x1 + 16, ey + 28, txt_fit(e.goal + "   (" + e.focus + ", tier "
                     + string(e.tier) + ")", 2, 760), 2, C.ink);
            draw_txt(x1 + 16, ey + 54, txt_fit("Did:  " + e.chain_words, 2, 760), 2, C.wall);
            draw_txt(x1 + 16, ey + 78, txt_fit("Said: " + e.guess, 2, 760), 2, C.cool);

            // the ending and the XP
            var xw = 300;
            var is_choice = variable_struct_exists(e, "result_word");
            var oword = is_choice ? e.result_word : outcome_word(e.outcome);
            var ogood = is_choice ? (e.xp == 2) : (e.outcome == "win");
            draw_txt(x2 - xw * 0.5, ey + 16, oword, 2,
                     ogood ? C.good : C.bad, fa_center, fa_top);
            draw_txt(x2 - xw * 0.5, ey + 42, "+" + string(e.xp) + (variable_struct_exists(e, "result_word") ? " pts" : " XP"), 4, C.ink, fa_center, fa_top);
            draw_txt(x2 - xw * 0.5, ey + 88, "credit: " + e.credit, 1, C.wall, fa_center, fa_top);
            draw_txt(x1 + 16, ey + 100, txt_fit(e.why, 1, 900), 1, C.wall);
        }

        // hide anything poking out of the list area
        draw_set_colour(C.sky);
        draw_rectangle(0, 276, SCR_W, list_top - 1, false);
        draw_rectangle(0, list_bot + 1, SCR_W, SCR_H, false);

        // scroll bar
        var view_h = list_bot - list_top;
        var total  = n * ENTRY_H;
        if (total > view_h) {
            var bar_h = max(40, view_h * (view_h / total));
            var bar_y = list_top + (view_h - bar_h) * (scroll / max(1, total - view_h));
            draw_set_colour(C.wall);
            draw_rectangle(SCR_W - 30, list_top, SCR_W - 18, list_bot, false);
            draw_set_colour(C.gold);
            draw_rectangle(SCR_W - 30, bar_y, SCR_W - 18, bar_y + bar_h, false);
        }
        draw_txt(SCR_W * 0.5, 282, "Roll the wheel to see more", 1, C.panel_lo, fa_center, fa_top);
    }
}

// ---------------- buttons ----------------
draw_text_button(rect_menu[0], rect_menu[1], rect_menu[2], rect_menu[3],
                 "Main menu", 3, hit_rect(mx, my, rect_menu), C.panel);
draw_text_button(rect_again[0], rect_again[1], rect_again[2], rect_again[3],
                 "Play again", 3, hit_rect(mx, my, rect_again));
draw_back_button(mx, my, "Main menu");
