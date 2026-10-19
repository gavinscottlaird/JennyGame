var C  = ui_colours();
var A  = art_objects();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

draw_backdrop(true);

// ---------------------------------------------------------------- objects
for (var oi = 0; oi < array_length(sc.spots); oi++) {
    var okey   = sc.spots[oi];
    var op     = places[$ okey];
    var bounce = (act_key == okey) ? -abs(sin(anim_t * 0.35)) * 10 : 0;
    draw_set_alpha(0.18);
    draw_set_colour(C.shade);
    draw_rectangle(op.x - OBJ_W * 0.4, op.y + OBJ_H - 6, op.x + OBJ_W * 0.4, op.y + OBJ_H + 2, false);
    draw_set_alpha(1);
    draw_pixel_map(A[$ okey].map, A[$ okey].pal, op.x - OBJ_W * 0.5, op.y + bounce, OBJ_SCALE);
}

// ---------------------------------------------------------------- character
var stage  = result_on;                        // on the ending, step into the spotlight
var draw_x = stage ? SCR_W * 0.5 : px;
var draw_y = stage ? 392 : py;
var bob    = (moving && !stage) ? ((walk_t div 6) % 2) * -3 : 0;
var gag    = stage ? anim[array_length(anim) - 1].gag : "";
var flip   = false;
var lean   = 0;

if (stage) {
    switch (gag) {
        case "cheer":  bob  = -abs(sin(anim_t * 0.12)) * 16; break;
        case "spin":   flip = true; lean = sin(anim_t * 0.25) * 12; break;
        case "wobble": lean = sin(anim_t * 0.09) * 10; break;
        case "fly":    lean = sin(anim_t * 0.3) * 6;
                       bob  = -abs(sin(anim_t * 0.2)) * 8; break;
        case "pile":   lean = sin(anim_t * 0.12) * 5; break;
    }
}

draw_set_alpha(0.22);
draw_set_colour(C.shade);
draw_rectangle(draw_x - 26, draw_y - 6, draw_x + 26, draw_y + 4, false);
draw_set_alpha(1);

draw_pixel_map(art.map, art.pal,
               draw_x - CHAR_W * 0.5 + lean, draw_y - CHAR_H + bob,
               CHAR_SCALE, 1, flip);

// ---- the funny extras that play with the ending ----
if (stage) {
    if (gag == "pile") {
        // the same thing over and over, stacked on the player's head
        var pkey = sc.obsess;
        var pbest = 0;
        for (var qi = 0; qi < array_length(sc.spots); qi++) {
            var pc = chain_count(chain, sc.spots[qi]);
            if (pc > pbest) { pbest = pc; pkey = sc.spots[qi]; }
        }
        var stack = max(3, pbest);
        for (var ps = 0; ps < stack; ps++) {
            var psx = draw_x - OBJ_GRID * 2.4 * 0.5 + sin(anim_t * 0.1 + ps) * 6;
            var psy = draw_y - CHAR_H - 34 - ps * 30;
            draw_pixel_map(A[$ pkey].map, A[$ pkey].pal, psx, psy, 2.4);
        }
    }
    if (gag == "fly") {
        // everything they grabbed, flying round their head
        var fn = min(4, array_length(chain));
        for (var fs = 0; fs < fn; fs++) {
            var fang = anim_t * 0.05 + (fs / max(1, fn)) * 2 * pi;
            var fox  = draw_x + cos(fang) * 150 - OBJ_GRID * 1.1;
            var foy  = draw_y - 90 + sin(fang) * 54 - OBJ_GRID * 1.1;
            draw_pixel_map(A[$ chain[fs]].map, A[$ chain[fs]].pal, fox, foy, 2.2);
        }
    }
    if (gag == "cheer") {
        for (var ks = 0; ks < 26; ks++) {
            var kx = (ks * 137) % SCR_W;
            var ky = ((anim_t * 3 + ks * 61) % 560) + ROOM_TOP;
            draw_set_colour(confetti_colour(ks));
            draw_rectangle(kx, ky, kx + 7, ky + 7, false);
        }
    }
    if (gag == "wobble") {
        draw_set_colour(C.cool);
        var wdy = (anim_t * 2) % 40;
        draw_rectangle(draw_x + 26, draw_y - CHAR_H + 10 + wdy,
                       draw_x + 34, draw_y - CHAR_H + 22 + wdy, false);
    }
}

// ---------------------------------------------------------------- name tag
// while the ending gag piles things over the character's head, the tag
// moves under the feet instead of fighting it for space
draw_name_tag(draw_x, draw_y - CHAR_H + bob, draw_y, global.cur.name,
              stage ? [] : avoid, stage);

// ---------------------------------------------------------------- speech bubble
if (say != "") {
    var sw  = txt_w(say, 2) + 24;
    var sbx = clamp(draw_x, 20 + sw * 0.5, SCR_W - 20 - sw * 0.5);
    var sby = draw_y - CHAR_H - 74;
    draw_panel(sbx - sw * 0.5, sby, sbx + sw * 0.5, sby + 34);
    draw_txt(sbx, sby + 17, say, 2, C.ink, fa_center, fa_middle);
    draw_set_colour(C.ink);
    draw_triangle(sbx - 8, sby + 38, sbx + 8, sby + 38, sbx, sby + 52, false);
}

// ---------------------------------------------------------------- action buttons
if (!result_on) {
    for (var bi = 0; bi < array_length(sc.spots); bi++) {
        var bkey = sc.spots[bi];
        var bp   = places[$ bkey];
        var bhot = (state == "pick") && hit_circle(mx, my, bp.bx, bp.by, BTN_R + 3);
        var btip = "";
        if (is_choice && variable_struct_exists(sc.describe, bkey)) btip = sc.describe[$ bkey];
        var bon  = (state == "pick") && (!is_choice || chain_count(chain, bkey) == 0);
        draw_action_button(bp.bx, bp.by, A[$ bkey], bhot, chain_count(chain, bkey), bon, btip);
    }
}

// ---------------------------------------------------------------- top: goal + chain
draw_set_alpha(0.86);
draw_set_colour(C.ink);
draw_rectangle(0, 0, SCR_W, 92, false);
draw_set_alpha(1);

if (is_choice) {
    draw_txt(24, 10, sit_text, 2, C.gold);
} else {
    draw_txt(24, 12, sc.goal, 2, C.gold);
    draw_txt(24, 42, "Tier " + string(sc.tier) + ": " + sc.tier_kid, 1, C.panel_lo);
}

var chx = is_choice ? 24 : 330;
if (is_choice && array_length(chain) > 0) {
    draw_txt(chx, CHAIN_Y, "Your plan:", 2, C.panel_lo, fa_left, fa_middle);
    chx += txt_w("Your plan:", 2) + 12;
}
if (array_length(chain) == 0) {
    var hint = is_choice ? "Tap the round buttons in the order you want."
                         : "Pick what to do. Tap the round buttons.";
    draw_txt(chx, CHAIN_Y, hint, 2, C.panel_lo, fa_left, fa_middle);
} else {
    for (var ci = 0; ci < array_length(chain); ci++) {
        var clab = chain_label(chain[ci]);
        var cw   = txt_w(clab, 2) + 18;
        draw_set_colour(C.gold);
        draw_rectangle(chx, CHAIN_Y - 16, chx + cw, CHAIN_Y + 16, false);
        draw_txt(chx + cw * 0.5, CHAIN_Y, clab, 2, C.ink, fa_center, fa_middle);
        chx += cw + 6;
        if (ci < array_length(chain) - 1) {
            draw_txt(chx, CHAIN_Y, ">", 2, C.white, fa_left, fa_middle);
            chx += 20;
        }
    }
}

// choice levels: the reminder stays on screen while planning
if (is_choice && (state == "pick" || state == "choose")) {
    var rtw = txt_w(sc.reminder, 2) + 32;
    draw_set_alpha(0.86);
    draw_set_colour(C.ink);
    draw_rectangle(SCR_W * 0.5 - rtw * 0.5, 100, SCR_W * 0.5 + rtw * 0.5, 132, false);
    draw_set_alpha(1);
    draw_txt(SCR_W * 0.5, 116, sc.reminder, 2, C.bad, fa_center, fa_middle);
}

// take the last pick back
if (state == "pick" && array_length(chain) > 0) {
    var uhot = hit_circle(mx, my, UNDO_X, UNDO_Y, 20);
    draw_set_colour(uhot ? C.bad : C.wall);
    draw_circle(UNDO_X, UNDO_Y, 20, false);
    draw_set_colour(C.white);
    draw_circle(UNDO_X, UNDO_Y, 20, true);
    draw_triangle(UNDO_X + 6, UNDO_Y - 9, UNDO_X + 6, UNDO_Y + 9, UNDO_X - 7, UNDO_Y, false);
    if (uhot) draw_txt(UNDO_X, UNDO_Y + 30, "Take one back", 1, C.white, fa_center, fa_top);
}

// XP badge
draw_set_colour(C.gold);
draw_rectangle(SCR_W - 240, 10, SCR_W - 110, 44, false);
draw_txt(SCR_W - 175, 27, "XP " + string(current_xp()), 2, C.ink, fa_center, fa_middle);

// ---------------------------------------------------------------- bottom bar
draw_set_alpha(0.92);
draw_set_colour(C.ink);
draw_rectangle(0, BAR_Y, SCR_W, SCR_H, false);
draw_set_alpha(1);

var go_txt = is_choice ? "I'm ready to guess" : "Check what happens";
if (state == "intro")  go_txt = "Start";
if (state == "choose") go_txt = "Show me what happens";
if (result_on) go_txt = (kind == "win") ? "Next one" : "Try again";
var go_r   = rect_go();
var go_on  = (result_on || array_length(chain) > 0 || state == "intro");
if (state == "choose") go_on = (pick >= 0);
if (state == "anim" && !result_on) go_on = false;
var go_hot = hit_rect(mx, my, go_r) && go_on;
draw_text_button(go_r[0], go_r[1], go_r[2], go_r[3], go_txt, 3, go_hot, go_on ? C.gold : C.panel_lo);

// bottom-left square: end the session
draw_back_button(mx, my, "All done");

// bottom-right circle: the time machine, only once the show is over
if (result_on) {
    var rhot = hit_circle(mx, my, REW_X, REW_Y, REW_R + 4);
    draw_set_colour(C.ink);
    draw_circle(REW_X, REW_Y, REW_R + 4, false);
    draw_set_colour(rhot ? C.gold : C.cool);
    draw_circle(REW_X, REW_Y, REW_R, false);
    draw_set_colour(C.ink);
    draw_circle(REW_X, REW_Y, REW_R - 8, true);
    draw_line_width(REW_X, REW_Y, REW_X, REW_Y - 10, 3);
    draw_line_width(REW_X, REW_Y, REW_X + 8, REW_Y + 4, 3);
    draw_triangle(REW_X - REW_R + 2, REW_Y - 6, REW_X - REW_R + 12, REW_Y - 12,
                  REW_X - REW_R + 12, REW_Y, false);
    if (rhot) draw_txt(REW_X, REW_Y - REW_R - 26, "Go back", 2, C.white, fa_center, fa_top);
}

// ---------------------------------------------------------------- ending panel
if (result_on && is_choice) {
    var qx1 = 120, qx2 = SCR_W - 120, qy1 = 404, qy2 = 650;
    var qw  = qx2 - qx1 - 60;
    draw_set_alpha(0.55);
    draw_set_colour(C.shade);
    draw_rectangle(0, ROOM_TOP, SCR_W, ROOM_BOT, false);
    draw_set_alpha(1);

    var matched = (outcome_score.xp == 2);
    draw_panel(qx1, qy1, qx2, qy2);
    draw_txt(SCR_W * 0.5, qy1 + 24, matched ? "Your guess matched!" : "Not what you guessed!", 3,
             matched ? C.good : C.bad, fa_center, fa_middle);
    draw_txt_wrap(SCR_W * 0.5, qy1 + 48, ending.text, 2, C.ink, qw);
    draw_txt(SCR_W * 0.5, qy1 + 120, txt_fit("You guessed: " + sc.predict[pick], 2, qw), 2, C.wall, fa_center, fa_top);
    if (!matched) {
        draw_txt(SCR_W * 0.5, qy1 + 146, txt_fit("What happened: " + sc.predict[ending.pick], 2, qw), 2, C.wall, fa_center, fa_top);
    }
    draw_txt(SCR_W * 0.5, qy2 - 62, "You got " + string(outcome_score.xp)
             + (outcome_score.xp == 1 ? " point" : " points"), 3, C.ink, fa_center, fa_top);
    draw_txt_wrap(SCR_W * 0.5, qy2 - 26, outcome_score.why, 1, C.wall, qw);
} else if (result_on) {
    var rx1 = 120, rx2 = SCR_W - 120, ry1 = 452, ry2 = 640;
    draw_set_alpha(0.55);
    draw_set_colour(C.shade);
    draw_rectangle(0, ROOM_TOP, SCR_W, ROOM_BOT, false);
    draw_set_alpha(1);

    draw_panel(rx1, ry1, rx2, ry2);
    draw_txt(SCR_W * 0.5, ry1 + 22, (kind == "win") ? "It worked!" : "Uh oh!", 3,
             (kind == "win") ? C.good : C.bad, fa_center, fa_middle);
    draw_txt_wrap(SCR_W * 0.5, ry1 + 44, anim[array_length(anim) - 1].text, 2, C.ink, rx2 - rx1 - 60);
    draw_txt(SCR_W * 0.5, ry2 - 56, "You got " + string(outcome_score.xp) + " XP", 3, C.ink, fa_center, fa_top);
    draw_txt_wrap(SCR_W * 0.5, ry2 - 24, outcome_score.why, 1, C.wall, rx2 - rx1 - 60);
}

// ---------------------------------------------------------------- the modal
if (state == "modal") {
    draw_set_alpha(0.78);
    draw_set_colour(C.shade);
    draw_rectangle(0, 0, SCR_W, SCR_H, false);
    draw_set_alpha(1);

    var mw = 900, mh = 260;
    var mx1 = (SCR_W - mw) * 0.5, my1 = (SCR_H - mh) * 0.5;
    draw_panel(mx1, my1, mx1 + mw, my1 + mh);
    draw_txt(SCR_W * 0.5, my1 + 34, "What will happen?", 4, C.ink, fa_center, fa_middle);

    var f1 = mx1 + 40, f2 = mx1 + mw - 40, g1 = my1 + 90, g2 = my1 + 150;
    draw_set_colour(C.ink);
    draw_rectangle(f1 - 3, g1 - 3, f2 + 3, g2 + 3, false);
    draw_set_colour(C.white);
    draw_rectangle(f1, g1, f2, g2, false);
    var shown = guess;
    while (txt_w(shown, 2) > (f2 - f1 - 30) && string_length(shown) > 1) {
        shown = string_delete(shown, 1, 1);
    }
    draw_txt(f1 + 14, (g1 + g2) * 0.5, shown, 2, C.ink, fa_left, fa_middle);
    if ((current_time div 400) % 2 == 0) {
        var caret = f1 + 16 + txt_w(shown, 2);
        draw_set_colour(C.ink);
        draw_rectangle(caret, g1 + 12, caret + 3, g2 - 12, false);
    }
    draw_txt(SCR_W * 0.5, my1 + 180, "Type your guess. Then press Enter.", 2, C.wall, fa_center, fa_top);
    draw_txt(SCR_W * 0.5, my1 + 212, "Say what you will do and what you think will happen.", 1, C.wall, fa_center, fa_top);
}

// ---------------------------------------------------------------- choice levels: situation card
if (state == "intro") {
    draw_set_alpha(0.78);
    draw_set_colour(C.shade);
    draw_rectangle(0, 0, SCR_W, BAR_Y, false);
    draw_set_alpha(1);

    var iw = 1000, ih = 330;
    var ix1 = (SCR_W - iw) * 0.5, iy1 = 150;
    draw_panel(ix1, iy1, ix1 + iw, iy1 + ih);
    draw_txt(SCR_W * 0.5, iy1 + 36, sc.tier_name, 4, C.ink, fa_center, fa_middle);
    draw_txt_wrap(SCR_W * 0.5, iy1 + 84, sit_text, 3, C.ink, iw - 80);
    draw_txt_wrap(SCR_W * 0.5, iy1 + 170, sc.reminder, 2, C.bad, iw - 80);
    draw_txt_wrap(SCR_W * 0.5, iy1 + 220,
                  "Put the mouse on a round button to see what it does. Tap the buttons in the order you want. Then guess what will happen.",
                  2, C.wall, iw - 120);
}

// ---------------------------------------------------------------- choice levels: the guess menu
if (state == "choose") {
    draw_set_alpha(0.82);
    draw_set_colour(C.shade);
    draw_rectangle(0, 0, SCR_W, BAR_Y, false);
    draw_set_alpha(1);

    draw_txt(SCR_W * 0.5, 150, "What do you think will happen?", 3, C.white, fa_center, fa_middle);
    var plan_words = "";
    for (var pj = 0; pj < array_length(chain); pj++) plan_words += (pj > 0 ? " > " : "") + chain_label(chain[pj]);
    draw_txt(SCR_W * 0.5, 186, "Your plan: " + plan_words, 2, C.panel_lo, fa_center, fa_middle);

    for (var gi = 0; gi < array_length(sc.predict); gi++) {
        var gr   = choice_rect(gi);
        var ghot = hit_rect(mx, my, gr);
        var gsel = (pick == gi);
        draw_panel(gr[0], gr[1], gr[2], gr[3], gsel ? C.gold : (ghot ? C.white : C.panel_lo));
        draw_txt(gr[0] + 34, (gr[1] + gr[3]) * 0.5, string(gi + 1) + ".", 3, C.ink, fa_center, fa_middle);
        draw_txt_wrap(gr[0] + 64, gr[1] + 10, sc.predict[gi], 2, C.ink, gr[2] - gr[0] - 84, fa_left);
    }
    var hint2 = (pick < 0) ? "Tap the one you think will happen." : "Then press the button below.";
    draw_txt(SCR_W * 0.5, 532, hint2, 2, C.white, fa_center, fa_top);
    draw_txt(SCR_W * 0.5, 562, "Want to change your plan? Press Esc.", 1, C.panel_lo, fa_center, fa_top);
}
