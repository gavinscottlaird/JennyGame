var mx    = device_mouse_x_to_gui(0);
var my    = device_mouse_y_to_gui(0);
var click = mouse_check_button_pressed(mb_left);

// bottom-left arrow: end the session. Always there, except while the modal is up.
if (state != "modal" && click && hit_rect(mx, my, rect_end())) {
    end_session();
    exit;
}

switch (state) {

    // ---------------- choice levels: the situation card ----------------
    case "intro": {
        if ((click && hit_rect(mx, my, rect_go())) || keyboard_check_pressed(vk_enter)) {
            state = "pick";
        }
    } break;

    // ---------------- choice levels: pick one of four guesses ----------------
    case "choose": {
        if (click) {
            for (var ci = 0; ci < array_length(sc.predict); ci++) {
                if (hit_rect(mx, my, choice_rect(ci))) { pick = ci; break; }
            }
            if (pick >= 0 && hit_rect(mx, my, rect_go())) submit_choice();
        }
        // change the plan
        if (keyboard_check_pressed(vk_escape)) { state = "pick"; pick = -1; }
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
            // an action button above an object
            for (var i = 0; i < array_length(sc.spots); i++) {
                var k = sc.spots[i];
                var p = places[$ k];
                if (hit_circle(mx, my, p.bx, p.by, BTN_R + 3)) {
                    // choice levels: each thing can be picked once
                    var can = !is_choice || chain_count(chain, k) == 0;
                    if (can && array_length(chain) < 8) array_push(chain, k);
                    break;
                }
            }
            // take the last one back
            if (array_length(chain) > 0 && hit_circle(mx, my, UNDO_X, UNDO_Y, 20)) {
                array_pop(chain);
            }
            // "Check what happens"
            if (array_length(chain) > 0 && hit_rect(mx, my, rect_go())) {
                if (is_choice) {
                    state = "choose";       // pick from the four endings
                    pick  = -1;
                } else {
                    state = "modal";
                    guess = "";
                    keyboard_string = "";
                }
            }
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
                    result_on = true;
                    say       = "";
                } break;
            }
        }

        if (result_on && click) {
            if (hit_circle(mx, my, REW_X, REW_Y, REW_R + 4)) {
                reset_scene();                       // time machine
            } else if (hit_rect(mx, my, rect_go())) {
                if (kind == "win") {
                    next_scenario();
                    room_restart();                  // load the next problem
                } else {
                    reset_scene();                   // "Try again"
                }
            }
        }
    } break;
}
