ui_begin();
var C  = ui_colours();
var A  = art_objects();
var mx = ui_mx();
var my = ui_my();
var L  = plan_layout();
var G  = is_choice ? guide_now() : undefined;
var matched = is_choice && result_on && outcome_score != undefined && outcome_score.xp == 2;

draw_backdrop(true);

// ---------------------------------------------------------------- objects
for (var oi = 0; oi < array_length(sc.spots); oi++) {
    var okey   = sc.spots[oi];
    var op     = places[$ okey];
    var bounce = (act_key == okey) ? -abs(sin(anim_t * 0.35)) * 10 : 0;
    // a little hop when it is added to the plan
    if (variable_struct_exists(hop, okey)) {
        var ht = t - hop[$ okey];
        if (ht >= 0 && ht < 24) bounce -= sin(ht / 24 * pi) * 16;
    }
    draw_set_alpha(0.18);
    draw_set_colour(C.shade);
    draw_rectangle(op.x - OBJ_W * 0.4, op.y + OBJ_H - 6, op.x + OBJ_W * 0.4, op.y + OBJ_H + 2, false);
    draw_set_alpha(1);
    draw_pixel_map(A[$ okey].map, A[$ okey].pal, op.x - OBJ_W * 0.5, op.y + bounce, OBJ_SCALE);

    // choice levels: what each thing does is always written under it
    // (no need to find it by hovering), plus its step number once it is in the plan
    if (is_choice && !result_on && variable_struct_exists(sc.describe, okey)) {
        var cap   = sc.describe[$ okey];
        var cap_w = 250;
        var cap_y = op.y + OBJ_H + 14;
        var cap_h = txt_wrap_h(cap, 1.5, cap_w, true);
        var c_hot = (state == "pick") && hit_circle(mx, my, op.bx, op.by, BTN_R + 3);
        draw_set_alpha(c_hot ? 0.95 : 0.75);
        draw_set_colour(C.ink);
        draw_rectangle(op.x - cap_w * 0.5 - 12, cap_y - 6, op.x + cap_w * 0.5 + 12, cap_y + cap_h + 6, false);
        draw_set_alpha(1);
        draw_txt_wrap(op.x, cap_y, cap, 1.5, c_hot ? C.gold : C.white, cap_w, fa_center, fa_top, true);

        var step_no = 0;
        for (var q = 0; q < array_length(chain); q++) if (chain[q] == okey) step_no = q + 1;
        if (step_no > 0) {
            var sy  = cap_y + cap_h + 22;
            var stx = "Step " + string(step_no) + " of your plan";
            var sw  = txt_w(stx, 1, true) + 40;
            draw_set_colour(C.ink);
            draw_rectangle(op.x - sw * 0.5 - 3, sy - 16, op.x + sw * 0.5 + 3, sy + 16, false);
            draw_set_colour(C.good);
            draw_rectangle(op.x - sw * 0.5, sy - 13, op.x + sw * 0.5, sy + 13, false);
            draw_tick(op.x - sw * 0.5 + 16, sy, 16, C.white);
            draw_txt(op.x + 12, sy, stx, 1, C.white, fa_center, fa_middle, 1, true);
        }
    }
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
    if (gag == "cheer" || matched) {
        // confetti: for a win, and whenever the guess matched
        for (var ks = 0; ks < 34; ks++) {
            var kx = (ks * 137 + 20) % SCR_W;
            var ky = ((result_t * 3 + ks * 61) % 560) + ROOM_TOP;
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
    var sw2 = txt_w(say, 2, true) + 28;
    var sbx = clamp(draw_x, 20 + sw2 * 0.5, SCR_W - 20 - sw2 * 0.5);
    var sby = draw_y - CHAR_H - 78;
    draw_panel(sbx - sw2 * 0.5, sby, sbx + sw2 * 0.5, sby + 38);
    draw_txt(sbx, sby + 18, say, 2, C.ink, fa_center, fa_middle, 1, true);
    draw_set_colour(C.ink);
    draw_triangle(sbx - 8, sby + 42, sbx + 8, sby + 42, sbx, sby + 56, false);
}

// ---------------------------------------------------------------- action buttons
if (!result_on) {
    for (var bi = 0; bi < array_length(sc.spots); bi++) {
        var bkey  = sc.spots[bi];
        var bp    = places[$ bkey];
        var bhot  = (state == "pick") && hit_circle(mx, my, bp.bx, bp.by, BTN_R + 3);
        var btip  = "";
        var bon   = (state == "pick") && (!is_choice || chain_count(chain, bkey) == 0);
        var bord  = 0;
        var bglow = 0;
        if (is_choice) {
            for (var q2 = 0; q2 < array_length(chain); q2++) if (chain[q2] == bkey) bord = q2 + 1;
            // after the first pick, the ones still free glow softly: "you can add me too"
            if (bon && array_length(chain) > 0) bglow = 0.5 + 0.5 * sin(t * 0.12);
        }
        draw_action_button(bp.bx, bp.by, A[$ bkey], bhot, chain_count(chain, bkey), bon,
                           btip, !is_choice, bord, bglow);
        // nothing picked yet: bouncing arrows point at the round buttons
        if (is_choice && state == "pick" && array_length(chain) == 0) {
            draw_pointer(bp.bx, bp.by - BTN_R - 26 + sin(t * 0.15) * 6, 13, "down", C.gold);
        }
    }
}

// ---------------------------------------------------------------- top bar
draw_band(ui_top(), 92, C.ink, 0.92);

// line 1: the problem
if (is_choice) {
    draw_txt(24, 26, txt_fit(sit_text, 2, SCR_W - 300, true), 2, C.gold, fa_left, fa_middle, 1, true);
} else {
    draw_txt(24, 22, sc.goal, 2, C.gold, fa_left, fa_middle, 1, true);
    draw_txt(24, 48, "Tier " + string(sc.tier) + ": " + sc.tier_kid, 1, C.panel_lo);
}

// points box, top right (it pulses when points come in)
var bx1 = SCR_W - 214, bx2 = SCR_W - 64, by1 = 10, by2 = 42;
var bpul = (result_on && result_t < 40) ? (1 - result_t / 40) * 6 : 0;
draw_set_colour(C.ink);
draw_rectangle(bx1 - 3 - bpul, by1 - 3 - bpul, bx2 + 3 + bpul, by2 + 3 + bpul, false);
draw_set_colour(C.gold);
draw_rectangle(bx1 - bpul, by1 - bpul, bx2 + bpul, by2 + bpul, false);
draw_txt((bx1 + bx2) * 0.5, 26, (is_choice ? "Points: " : "XP ") + string(current_xp()),
         2, C.ink, fa_center, fa_middle, 1, true);

// line 2: the plan, step by step
if (array_length(chain) == 0) {
    var hint = is_choice ? "Your plan: (empty)" : "Pick what to do. Tap the round buttons.";
    draw_txt(L.x0, CHAIN_Y, hint, 2, C.panel_lo, fa_left, fa_middle);
} else {
    draw_txt(L.x0, CHAIN_Y, "Your plan:", 2, C.panel_lo, fa_left, fa_middle, 1, true);
    for (var ci = 0; ci < array_length(chain); ci++) {
        var r    = L.chips[ci];
        var born = (ci < array_length(chip_born)) ? chip_born[ci] : 0;
        if (born > t) {
            // still flying up: show where it will land
            draw_set_alpha(0.35);
            draw_set_colour(C.gold);
            draw_rectangle(r[0], r[1], r[2], r[3], true);
            draw_set_alpha(1);
        } else {
            var age   = t - born;
            var doing = (state == "anim" && !result_on && (anim_i div 2) == ci);
            var fill  = (age < 30 && (age div 6) % 2 == 0) ? C.white : C.gold;   // flashes as it lands
            if (doing) {
                // the step being acted out right now
                draw_set_colour(C.white);
                draw_rectangle(r[0] - 7, r[1] - 7, r[2] + 7, r[3] + 7, false);
            }
            draw_set_colour(C.ink);
            draw_rectangle(r[0] - 3, r[1] - 3, r[2] + 3, r[3] + 3, false);
            draw_set_colour(fill);
            draw_rectangle(r[0], r[1], r[2], r[3], false);
            draw_num_badge(r[0] + 17, CHAIN_Y, 11, ci + 1, C.ink);
            draw_txt(r[0] + 34, CHAIN_Y, chain_label(chain[ci]), 2, C.ink, fa_left, fa_middle, 1, true);
        }
        if (ci < array_length(chain) - 1) draw_pointer(r[2] + 14, CHAIN_Y, 7, "right", C.white);
    }

    // "Take back": the last step comes out of the plan
    if (state == "pick" && L.undo != undefined) {
        var u    = L.undo;
        var uhot = hit_rect(mx, my, u);
        if (uhot) ui_hand();
        draw_set_colour(C.ink);
        draw_rectangle(u[0] - 3, u[1] - 3, u[2] + 3, u[3] + 3, false);
        draw_set_colour(uhot ? C.bad : C.wall);
        draw_rectangle(u[0], u[1], u[2], u[3], false);
        draw_pointer(u[0] + 20, CHAIN_Y, 8, "left", C.white);
        draw_txt(u[0] + 38, CHAIN_Y, "Take back", 2, C.white, fa_left, fa_middle, 1, true);
    }
}

// choice levels: the three steps, so you always know where you are
if (is_choice) {
    var cur = 0;
    if (state == "choose") cur = 1;
    if (state == "anim")   cur = result_on ? 3 : 2;
    var labs = ["Plan", "Guess", "Watch"];
    var wid  = [0, 0, 0];
    var tot  = 0;
    for (var si = 0; si < 3; si++) {
        wid[si] = 34 + txt_w(labs[si], 2, true) + 16;
        tot += wid[si];
    }
    tot += 2 * 26;
    var sx = SCR_W - 16 - tot;
    for (var sj = 0; sj < 3; sj++) {
        var sdone = (sj < cur), snow = (sj == cur);
        if (snow) {
            draw_set_colour(C.gold);
            draw_rectangle(sx, CHAIN_Y - 16, sx + wid[sj], CHAIN_Y + 16, false);
        }
        var ccx = sx + 17;
        if (sdone) {
            draw_set_colour(C.good);
            draw_circle(ccx, CHAIN_Y, 12, false);
            draw_tick(ccx, CHAIN_Y, 16, C.white);
        } else {
            draw_num_badge(ccx, CHAIN_Y, 11, sj + 1, snow ? C.ink : C.wall);
        }
        draw_txt(sx + 34, CHAIN_Y, labs[sj], 2, snow ? C.ink : (sdone ? C.white : C.panel_lo),
                 fa_left, fa_middle, 1, true);
        sx += wid[sj];
        if (sj < 2) {
            draw_pointer(sx + 13, CHAIN_Y, 6, "right", C.panel_lo);
            sx += 26;
        }
    }
}

// ---------------------------------------------------------------- bottom bar
draw_band(BAR_Y, ui_bottom(), C.ink, 0.94);

var go_r   = rect_go();
var go_on  = go_ready();
var go_hot = hit_rect(mx, my, go_r) && go_on;
if (go_on && state != "modal") draw_glow_rect(go_r, t, C.gold);      // "press this next"
draw_text_button(go_r[0], go_r[1], go_r[2], go_r[3], go_label(), 3, go_hot, go_on ? C.gold : C.panel_lo);

// bottom-left square: end the session
draw_back_button(mx, my, "All done");

// guess menu: a real button to go back and change the plan (Esc works too)
if (state == "choose") {
    draw_text_button(rect_change[0], rect_change[1], rect_change[2], rect_change[3],
                     "Change my plan", 2, hit_rect(mx, my, rect_change), C.panel);
}

// bottom-right circle: the time machine, only once the show is over
if (result_on) {
    var rhot = hit_rect(mx, my, rect_try);
    if (rhot) ui_hand();
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
    // always say what it does (it used to show only on hover)
    var rlab = is_choice ? "Try again" : "Go back";
    draw_txt(REW_X - REW_R - 14, REW_Y, rlab, 2, rhot ? C.gold : C.white, fa_right, fa_middle, 1, true);
}

// ---------------------------------------------------------------- ending panel
if (result_on && is_choice) {
    draw_band(ROOM_TOP, ROOM_BOT, C.shade, 0.3);

    // slides up and fades in
    var e    = ease_out_cubic(result_t / 16);
    var off  = (1 - e) * 40;
    var qx1  = 130, qx2 = SCR_W - 130, qy1 = 404 + off, qy2 = 652 + off;
    var qw   = qx2 - qx1 - 60;
    var hc   = matched ? C.good : C.bad;
    draw_panel(qx1, qy1, qx2, qy2, C.panel, hc);

    // header: tick or cross, what it means, and the points
    var hy  = qy1 + 32;
    var pop = ease_out_back(result_t / 18);
    draw_set_colour(C.ink);
    draw_circle(qx1 + 42, hy, 22 * pop + 3, false);
    draw_set_colour(hc);
    draw_circle(qx1 + 42, hy, 22 * pop, false);
    if (matched) draw_tick(qx1 + 42, hy, 26 * pop, C.white);
    else         draw_cross(qx1 + 42, hy, 24 * pop, C.white);
    draw_txt(qx1 + 76, hy, matched ? "Your guess matched!" : "Not what you guessed!", 3, hc,
             fa_left, fa_middle, 1, true);

    var pts  = outcome_score.xp;
    var ptxt = "+" + string(pts) + (pts == 1 ? " point" : " points");
    var pw   = txt_w(ptxt, 3, true) + 32;
    var pp   = ease_out_back((result_t - 10) / 16);
    if (result_t > 10) {
        var pcx = qx2 - 24 - pw * 0.5;
        draw_set_colour(C.ink);
        draw_rectangle(pcx - pw * 0.5 * pp - 3, hy - 22 * pp - 3, pcx + pw * 0.5 * pp + 3, hy + 22 * pp + 3, false);
        draw_set_colour(C.gold);
        draw_rectangle(pcx - pw * 0.5 * pp, hy - 22 * pp, pcx + pw * 0.5 * pp, hy + 22 * pp, false);
        if (pp > 0.6) draw_txt(pcx, hy, ptxt, 3, C.ink, fa_center, fa_middle, 1, true);
    }

    // what happened
    draw_txt_wrap(qx1 + 30, qy1 + 64, ending.text, 2, C.ink, qw, fa_left);

    // your guess next to what really happened
    draw_set_colour(C.panel_lo);
    draw_rectangle(qx1 + 24, qy1 + 124, qx2 - 24, qy1 + 126, false);
    var ry  = qy1 + 146;
    var lab = "You guessed:";
    if (matched) draw_tick(qx1 + 42, ry, 20, C.good);
    else         draw_cross(qx1 + 42, ry, 20, C.bad);
    draw_txt(qx1 + 62, ry, lab, 2, C.ink, fa_left, fa_middle, 1, true);
    var gx = qx1 + 62 + txt_w(lab, 2, true) + 10;
    draw_txt(gx, ry, txt_fit(string(pick + 1) + ". " + sc.predict[pick], 2, qx2 - 30 - gx),
             2, C.wall, fa_left, fa_middle);
    if (!matched) {
        ry += 30;
        lab = "What happened:";
        draw_tick(qx1 + 42, ry, 20, C.good);
        draw_txt(qx1 + 62, ry, lab, 2, C.ink, fa_left, fa_middle, 1, true);
        gx = qx1 + 62 + txt_w(lab, 2, true) + 10;
        draw_txt(gx, ry, txt_fit(string(ending.pick + 1) + ". " + sc.predict[ending.pick], 2, qx2 - 30 - gx),
                 2, C.wall, fa_left, fa_middle);
    }
    // why these points
    draw_txt(qx1 + 30, qy1 + 206, outcome_score.why, 1, C.wall, fa_left, fa_middle);

    // what to do next
    var nxt = has_next_level() ? "Next: press Next level. Or press Try again."
                               : "Next: press See my score. Or press Try again.";
    draw_pointer(qx1 + 40, qy1 + 232, 8, "right", C.ink);
    draw_txt(qx1 + 58, qy1 + 232, nxt, 2, C.ink, fa_left, fa_middle, 1, true);
} else if (result_on) {
    var rx1 = 120, rx2 = SCR_W - 120, ry1 = 452, ry2 = 640;
    draw_band(ROOM_TOP, ROOM_BOT, C.shade, 0.55);

    draw_panel(rx1, ry1, rx2, ry2);
    draw_txt(SCR_W * 0.5, ry1 + 22, (kind == "win") ? "It worked!" : "Uh oh!", 3,
             (kind == "win") ? C.good : C.bad, fa_center, fa_middle);
    draw_txt_wrap(SCR_W * 0.5, ry1 + 44, anim[array_length(anim) - 1].text, 2, C.ink, rx2 - rx1 - 60);
    draw_txt(SCR_W * 0.5, ry2 - 62, "You got " + string(outcome_score.xp) + " XP", 3, C.ink, fa_center, fa_top);
    draw_txt_wrap(SCR_W * 0.5, ry2 - 26, outcome_score.why, 1, C.wall, rx2 - rx1 - 60);
}

// ---------------------------------------------------------------- the modal (older levels)
if (state == "modal") {
    draw_band(ui_top(), ui_bottom(), C.shade, 0.78);

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
    draw_txt(SCR_W * 0.5, my1 + 214, "Say what you will do and what you think will happen.", 1, C.wall, fa_center, fa_top);
}

// ---------------------------------------------------------------- choice levels: situation card
if (state == "intro") {
    draw_band(ui_top(), BAR_Y, C.shade, 0.78);

    var iw = 1000, ih = 360;
    var ix1 = (SCR_W - iw) * 0.5, iy1 = 140;
    draw_panel(ix1, iy1, ix1 + iw, iy1 + ih);
    draw_txt(SCR_W * 0.5, iy1 + 40, sc.tier_name, 4, C.ink, fa_center, fa_middle);
    draw_txt_wrap(SCR_W * 0.5, iy1 + 84, sit_text, 3, C.ink, iw - 80);
    draw_txt_wrap(SCR_W * 0.5, iy1 + 176, sc.reminder, 2, C.bad, iw - 80, fa_center, fa_top, true);
    draw_txt_wrap(SCR_W * 0.5, iy1 + 222,
                  "Each round button is something you can do. Tap them in the order you want. Then guess what will happen.",
                  2, C.wall, iw - 120);
    draw_pointer(SCR_W * 0.5 - 150, iy1 + ih - 34, 8, "right", C.ink);
    draw_txt(SCR_W * 0.5 - 132, iy1 + ih - 34, "Press Start when you are ready.", 2, C.ink,
             fa_left, fa_middle, 1, true);
}

// ---------------------------------------------------------------- choice levels: the guess menu
if (state == "choose") {
    // the top bar (your plan, the three steps) stays visible above this
    draw_band(92, BAR_Y, C.shade, 0.84);

    for (var gi = 0; gi < array_length(sc.predict); gi++) {
        var gr   = choice_rect(gi);
        var ghot = hit_rect(mx, my, gr);
        var gsel = (pick == gi);
        if (ghot) ui_hand();
        var fill = gsel ? C.gold : (ghot ? C.white : (pick >= 0 ? C.panel_lo : C.panel));
        var lift = (ghot && !gsel) ? 3 : 0;
        if (gsel) {
            // a white frame that pulses out when it is picked
            var pf = (pick_t < 20) ? (1 - pick_t / 20) * 10 : 0;
            draw_set_colour(C.white);
            draw_rectangle(gr[0] - 9 - pf, gr[1] - 9 - pf, gr[2] + 9 + pf, gr[3] + 9 + pf, false);
        }
        draw_panel(gr[0], gr[1] - lift, gr[2], gr[3] - lift, fill);

        // number on the left; the one you picked gets a green tick instead
        var ncx = gr[0] + 38, ncy = (gr[1] + gr[3]) * 0.5 - lift;
        if (gsel) {
            var tp = ease_out_back(pick_t / 14);
            draw_set_colour(C.ink);
            draw_circle(ncx, ncy, 22 * tp + 3, false);
            draw_set_colour(C.good);
            draw_circle(ncx, ncy, 22 * tp, false);
            draw_tick(ncx, ncy, 26 * tp, C.white);
        } else {
            draw_num_badge(ncx, ncy, 19, gi + 1, C.ink);
        }

        var tw2 = gr[2] - gr[0] - (gsel ? 250 : 100);
        var th2 = txt_wrap_h(sc.predict[gi], 2, tw2);
        draw_txt_wrap(gr[0] + 76, ncy - th2 * 0.5, sc.predict[gi], 2, C.ink, tw2, fa_left);

        if (gsel) {
            var tag  = "Your guess";
            var tagw = txt_w(tag, 2, true) + 28;
            draw_set_colour(C.ink);
            draw_rectangle(gr[2] - 16 - tagw, ncy - 17, gr[2] - 16, ncy + 17, false);
            draw_txt(gr[2] - 16 - tagw * 0.5, ncy, tag, 2, C.white, fa_center, fa_middle, 1, true);
        }
    }
}

// ---------------------------------------------------------------- reminder
// choice levels: it stays on screen while planning and guessing
if (is_choice && (state == "pick" || state == "choose")) {
    var rtw = txt_w(sc.reminder, 2, true) + 36;
    draw_set_alpha(0.9);
    draw_set_colour(C.ink);
    draw_rectangle(SCR_W * 0.5 - rtw * 0.5, 100, SCR_W * 0.5 + rtw * 0.5, 132, false);
    draw_set_alpha(1);
    draw_txt(SCR_W * 0.5, 116, sc.reminder, 2, C.bad, fa_center, fa_middle, 1, true);
}

// ---------------------------------------------------------------- the help box
// Always in the same place, under the reminder. Top line: what just happened.
// Bottom line: what to do next. It pops in each time the words change.
if (G != undefined && (state == "pick" || state == "choose" || (state == "anim" && !result_on))) {
    var gkey = G.did + "|" + G.next;
    if (gkey != guide_key) {
        guide_key = gkey;
        guide_t   = 0;
    }
    var has_did = (G.did != "");
    var wmax    = 940;
    var wd      = has_did ? txt_w(G.did, 2) : 0;
    var wn      = txt_w(G.next, 2, true);
    var gw      = clamp(max(wd, wn) + 76, 420, wmax + 76);
    var gh      = has_did ? 76 : 46;
    var ge      = ease_out_cubic(guide_t / 12);
    var wig     = (shake_t < 24) ? sin(shake_t * 1.3) * (1 - shake_t / 24) * 10 : 0;
    var gx1     = SCR_W * 0.5 - gw * 0.5 + wig;
    var gy1     = 142 - (1 - ge) * 10;
    var flash   = (guide_t < 48) && ((guide_t div 8) % 2 == 0);

    draw_set_colour(flash ? (G.warn && has_did ? C.bad : C.gold) : C.ink);
    draw_rectangle(gx1 - 4, gy1 - 4, gx1 + gw + 4, gy1 + gh + 4, false);
    draw_set_colour(C.tag);
    draw_rectangle(gx1, gy1, gx1 + gw, gy1 + gh, false);

    var ly = gy1 + 23;
    if (has_did) {
        if (G.warn) {
            draw_set_colour(C.bad);
            draw_circle(gx1 + 26, ly, 12, false);
            draw_txt(gx1 + 26, ly - 1, "!", 2, C.white, fa_center, fa_middle, 1, true);
        } else {
            draw_set_colour(C.good);
            draw_circle(gx1 + 26, ly, 12, false);
            draw_tick(gx1 + 26, ly, 16, C.white);
        }
        draw_txt(gx1 + 48, ly, txt_fit(G.did, 2, wmax), 2, G.warn ? C.bad : C.good, fa_left, fa_middle);
        ly += 31;
    }
    draw_pointer(gx1 + 26, ly, 8, "right", C.gold);
    draw_txt(gx1 + 48, ly, txt_fit(G.next, 2, wmax, true), 2, C.white, fa_left, fa_middle, 1, true);
}

// ---------------------------------------------------------------- little effects
for (var fi = 0; fi < array_length(fx); fi++) {
    var f  = fx[fi];
    var fp = f.t / f.dur;
    switch (f.type) {
        case "ring": {
            // a burst where you clicked
            draw_halo(f.x, f.y, BTN_R + 4 + fp * 44, 1 + 7 * (1 - fp), f.col, 1 - fp);
        } break;
        case "fly": {
            // the picked thing flies up to its place in the plan
            var fe  = ease_out_cubic(fp);
            var fcx = lerp(f.x0, f.x1, fe);
            var fcy = lerp(f.y0, f.y1, fe) - sin(fp * pi) * 50;
            var fsc = lerp(0.55, 1, fe);
            var fw  = f.w * fsc * 0.5, fh = f.h * fsc * 0.5;
            draw_set_colour(C.ink);
            draw_rectangle(fcx - fw - 3, fcy - fh - 3, fcx + fw + 3, fcy + fh + 3, false);
            draw_set_colour(C.gold);
            draw_rectangle(fcx - fw, fcy - fh, fcx + fw, fcy + fh, false);
            if (fsc > 0.8) draw_txt(fcx + 8, fcy, f.label, 2, C.ink, fa_center, fa_middle, 1, true);
        } break;
        case "float": {
            // words that float up and fade, like "+2" by the points box
            draw_txt(f.x, f.y - fp * 34, f.text, 3, f.col, fa_center, fa_middle, 1 - fp * fp, true);
        } break;
    }
}

// a bouncing arrow at the big button when it is the thing to press next
if (is_choice) {
    var point_go = (state == "intro") || result_on
                || (G != undefined && G.dir == "down" && (state == "pick" || state == "choose"));
    if (point_go) draw_pointer(SCR_W * 0.5, 666 + sin(t * 0.18) * 4, 10, "down", C.gold);
}

ui_end();
