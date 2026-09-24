var C  = ui_colours();
var A  = art_objects();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var fl = focus_list();

draw_backdrop(false);

draw_txt_shadow(SCR_W * 0.5, 70, "What do you want to work on?", 4, C.gold, fa_center, fa_top);
draw_txt(SCR_W * 0.5, 130, "Hi " + global.cur.name + "! Pick one.", 3, C.panel, fa_center, fa_top);

// one picture for each tag
var icons = { school : "backpack", social : "ball", home : "bed", food : "fridge" };

for (var i = 0; i < array_length(fl); i++) {
    var r   = tag_rect(i);
    var hot = hit_rect(mx, my, r);
    draw_set_colour(hot ? C.gold : C.ink);
    draw_rectangle(r[0] - 5, r[1] - 5, r[2] + 5, r[3] + 5, false);
    draw_set_colour(hot ? C.panel : C.panel_lo);
    draw_rectangle(r[0], r[1], r[2], r[3], false);

    var ikey = icons[$ fl[i].key];
    draw_pixel_map(A[$ ikey].map, A[$ ikey].pal,
                   (r[0] + r[2]) * 0.5 - OBJ_W * 0.5, r[1] + 16, OBJ_SCALE);
    draw_txt((r[0] + r[2]) * 0.5, r[3] - 40, fl[i].label, 3, C.ink, fa_center, fa_top);
}

// typed word
var f1 = SCR_W * 0.5 - 300, f2 = SCR_W * 0.5 + 300, g1 = 510, g2 = 566;
draw_txt(SCR_W * 0.5, 478, "Or type a word and press Enter", 2, C.panel, fa_center, fa_top);
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

if (msg != "") draw_txt(SCR_W * 0.5, 584, msg, 2, C.bad, fa_center, fa_top);

draw_back_button(mx, my, "Back");
