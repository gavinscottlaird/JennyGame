var mx    = ui_mx();
var my    = ui_my();
var click = ui_click();

// every animation runs on its own clock
t++;
guide_t++;
shake_t++;
pick_t++;
if (result_on) result_t++;
for (var fi = array_length(fx) - 1; fi >= 0; fi--) {
    var fe = fx[fi];
    fe.t += 1;
    if (fe.t >= fe.dur) array_delete(fx, fi, 1);
}

// bottom-left arrow: end the session. Always there, except while the modal is up.
if (state != "modal" && click && hit_rect(mx, my, rect_end())) {
    end_session();
    exit;
}

switch (state) {

    // ---------------- choice levels: the situation card ----------------
    case "intro": {
        if ((click && hit_rect(mx, my, rect_go())) || keyboard_check_pressed(vk_enter)) {
            state    = "pick";
            did      = "";
            did_warn = false;
        }
    } break;

    // ---------------- choice levels: pick one of four guesses ----------------
    case "choose": {
        if (click) {
            var on_card = false;
            for (var ci = 0; ci < array_length(sc.predict); ci++) {
                if (hit_rect(mx, my, choice_rect(ci))) {
                    on_card = true;
                    if (pick != ci) {
                        pick     = ci;
                        pick_t   = 0;
                        did      = "You picked number " + string(ci + 1) + ".";
                        did_warn = false;
                    }
                    break;
                }
            }
            if (!on_card && hit_rect(mx, my, rect_go())) {
                if (pick >= 0) submit_choice();
                else nudge("First tap the ending you think will happen.");
            }
            if (state == "choose" && hit_rect(mx, my, rect_change)) back_to_plan();
        }
        if (state == "choose" && pick >= 0 && keyboard_check_pressed(vk_enter)) submit_choice();
        // change the plan
        if (state == "choose" && keyboard_check_pressed(vk_escape)) back_to_plan();
    } break;

    // ---------------- picking buttons ----------------
    case "pick": {
        var mvx = (keyboard_check(vk_right) || keyboard_check(ord("D")))
                - (keyboard_check(vk_left)  || keyboard_check(ord("A")));
        var mvy = (keyboard_check(vk_down)  || keyboard_check(ord("S")))
                - (keyboard_check(vk_up)    || keyboard_check(ord("W")));
        moving = (mvx != 0 || mvy != 0);
        if (moving) {
            // clamped with the TIGHT hitbox, so every avatar stops at the same
            // place no matter how tall its art is
            px = clamp(px + mvx * 5, half_w + 12, SCR_W - half_w - 12);
            py = clamp(py + mvy * 3, FLOOR_Y - 28, FLOOR_Y + 44);
            walk_t++;
        }

        if (click) {
            var used = false;

            // an action button above an object
            for (var i = 0; i < array_length(sc.spots); i++) {
                var k = sc.spots[i];
                var p = places[$ k];
                if (hit_circle(mx, my, p.bx, p.by, BTN_R + 3)) {
                    used = true;
                    // choice levels: each thing can be picked once
                    var can = !is_choice || chain_count(chain, k) == 0;
                    if (!can) {
                        nudge(chain_label(k) + " is already in your plan. Tap Take back to change it.");
                    } else if (array_length(chain) >= 8) {
                        nudge("Your plan is full.");
                    } else {
                        add_to_plan(k);
                    }
                    break;
                }
            }

            // "Take back": the last step comes out of the plan
            var L = plan_layout();
            if (!used && L.undo != undefined && hit_rect(mx, my, L.undo)) {
                undo_last();
                used = true;
            }

            // "I'm ready to guess" / "Check what happens"
            if (!used && hit_rect(mx, my, rect_go())) {
                if (array_length(chain) == 0) {
                    nudge("First tap a round button to make your plan.");
                } else if (is_choice) {
                    state    = "choose";       // pick from the four endings
                    pick     = -1;
                    did      = "Your plan: " + plan_words() + ".";
                    did_warn = false;
                } else {
                    state = "modal";
                    guess = "";
                    keyboard_string = "";
                }
            }
        }
        if (is_choice && array_length(chain) > 0 && keyboard_check_pressed(vk_enter)) {
            state    = "choose";
            pick     = -1;
            did      = "Your plan: " + plan_words() + ".";
            did_warn = false;
        }
    } break;

    // ---------------- typing the guess ----------------
    case "modal": {
        if (string_length(keyboard_string) > 60) {
            keyboard_string = string_copy(keyboard_string, 1, 60);
        }
        guess = keyboard_string;
        // the modal closes itself the moment the guess is entered
        if (keyboard_check_pressed(vk_enter) && str_trim(guess) != "") {
            submit_guess();
        }
        if (keyboard_check_pressed(vk_escape)) state = "pick";
    } break;

    // ---------------- watching what happens ----------------
    case "anim": {
        if (anim_i < array_length(anim)) {
            var st = anim[anim_i];
            anim_t++;
            switch (st.type) {
                case "walk": {
                    var d = st.tx - px;
                    moving = true;
                    if (abs(d) <= 12 || anim_t > st.frames) {
                        px = st.tx;
                        moving = false;
                        anim_i++;
                        anim_t = 0;
                    } else {
                        px += sign(d) * 12;
                        walk_t++;
                    }
                } break;

                case "act": {
                    act_key = st.key;
                    say     = st.text;
                    moving  = false;
                    if (anim_t > st.frames) {
                        anim_i++;
                        anim_t  = 0;
                        act_key = "";
                        say     = "";
                    }
                } break;

                case "result": {
                    if (!result_on) {
                        result_on = true;
                        on_result();
                    }
                    say = "";
                } break;
            }
        }

        // clicking while it plays: say why nothing happens yet
        if (!result_on && click && hit_rect(mx, my, rect_go())) {
            nudge("Watch first. The buttons come back at the end.");
        }

        if (result_on) {
            var go_key = keyboard_check_pressed(vk_enter);
            if (click && hit_rect(mx, my, rect_try)) {
                reset_scene();                       // time machine: try again
            } else if (go_key || (click && hit_rect(mx, my, rect_go()))) {
                if (is_choice) {
                    if (has_next_level()) {
                        next_scenario();
                        room_restart();              // on to the next level
                    } else {
                        end_session();               // last level: see the score
                    }
                } else if (kind == "win") {
                    next_scenario();
                    room_restart();                  // load the next problem
                } else {
                    reset_scene();                   // "Try again"
                }
            }
        }
    } break;
}
