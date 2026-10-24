/// The playing screen: make a plan, guess, watch what happens.
game_init();

sc     = current_scenario();
places = layout_positions(sc.spots);
avoid  = scene_avoid_rects(sc.spots, places);

chain  = [];
state  = "pick";            // pick -> modal -> anim   (choice levels: intro -> pick -> choose -> anim)
guess  = "";                // what the student typed
kind   = "";                // which ending happened
outcome_score = undefined;  // result of score_attempt

anim    = [];
anim_i  = 0;
anim_t  = 0;
act_key = "";               // object being used right now, for the little bounce
say     = "";               // speech bubble text
result_on = false;          // the ending panel is up

// the character
art     = art_chars()[$ global.cur.char];
half_w  = (art.hit[2] - art.hit[0] + 1) * CHAR_SCALE * 0.5;
px      = SCR_W * 0.5;
py      = FLOOR_Y;
walk_t  = 0;
moving  = false;
home_x  = px;
home_y  = py;

// ---- feedback: what just happened, and what to do next ----
// The help box under the reminder always says both. Every click also gets
// a small animation where it happened (see the Draw event).
t         = 0;              // frames on this screen; drives every animation
fx        = [];             // short effects: rings, flying plan chips, floating words
chip_born = [];             // frame each plan chip lands, one per plan step (it flashes)
did       = "";             // what just happened, in words (top line of the help box)
did_warn  = false;          // true = a "not yet" message (shown in red with a "!")
guide_key = "";             // help box words last frame, to spot a change
guide_t   = 999;            // frames since the help box changed (it pops in)
shake_t   = 999;            // frames since a "not yet" nudge (the help box wiggles)
hop       = {};             // object key -> frame it was added (the object hops)
pick_t    = 999;            // frames since a guess was picked in the menu
result_t  = 0;              // frames since the ending panel came up

// ---- choice levels (Jenny's levels): guess from a menu of four ----
is_choice = variable_struct_exists(sc, "mode") && sc.mode == "choice";
pick      = -1;             // which of the four endings the student chose
ending    = undefined;      // the ending that played
if (is_choice) {
    state    = "intro";     // show the situation card first
    sit_text = situation_text(sc);
}

// "Change my plan" (guess menu) and "Try again" (ending) click areas
rect_change = [110, 692, 420, 744];
rect_try    = [REW_X - REW_R - 150, REW_Y - 26, REW_X + REW_R + 4, REW_Y + 26];

/// screen box of guess number i in the menu
choice_rect = function(i) {
    var w = 1100, h = 66, gap = 12, top = 236;
    var x1 = (SCR_W - w) * 0.5;
    var y1 = top + i * (h + gap);
    return [x1, y1, x1 + w, y1 + h];
};

/// the plan in words: "Fridge > Bed"
plan_words = function() {
    var s = "";
    for (var i = 0; i < array_length(chain); i++) s += (i > 0 ? " > " : "") + chain_label(chain[i]);
    return s;
};

/// where the plan sits along the top: the chips, and the "Take back" button
plan_layout = function() {
    var out = { x0 : is_choice ? 24 : 330, chips : [], undo : undefined };
    var xx  = out.x0;
    var y1  = CHAIN_Y - 16, y2 = CHAIN_Y + 16;
    if (array_length(chain) > 0) xx += txt_w("Your plan:", 2, true) + 14;
    for (var i = 0; i < array_length(chain); i++) {
        var w = 34 + txt_w(chain_label(chain[i]), 2, true) + 14;
        array_push(out.chips, [xx, y1, xx + w, y2]);
        xx += w + 28;                          // room for the little arrow
    }
    if (array_length(chain) > 0) {
        xx -= 12;
        out.undo = [xx, y1, xx + 40 + txt_w("Take back", 2, true) + 12, y2];
    }
    return out;
};

/// a "not yet" message: the help box wiggles and says what to do first
nudge = function(msg) {
    did      = msg;
    did_warn = true;
    shake_t  = 0;
    guide_t  = 0;
};

/// adds a thing to the plan, with a burst, a chip that flies to the top,
/// and a hop
add_to_plan = function(k) {
    array_push(chain, k);
    var p   = places[$ k];
    var L   = plan_layout();
    var dst = L.chips[array_length(chain) - 1];
    array_push(fx, { type : "ring", t : 0, dur : 26, x : p.bx, y : p.by, col : ui_colours().gold });
    array_push(fx, { type : "fly", t : 0, dur : 30, x0 : p.bx, y0 : p.by,
                     x1 : (dst[0] + dst[2]) * 0.5, y1 : (dst[1] + dst[3]) * 0.5,
                     w : dst[2] - dst[0], h : dst[3] - dst[1],
                     label : chain_label(k), num : array_length(chain) });
    array_push(chip_born, t + 30);             // the chip lands in 30 frames
    hop[$ k] = t;
    did      = "You added " + chain_label(k) + " to your plan. It is step "
             + string(array_length(chain)) + ".";
    did_warn = false;
};

/// takes the last thing back out of the plan
undo_last = function() {
    var k = array_pop(chain);
    array_pop(chip_born);
    if (variable_struct_exists(places, k)) {
        var p = places[$ k];
        array_push(fx, { type : "ring", t : 0, dur : 22, x : p.bx, y : p.by, col : ui_colours().cool });
    }
    did      = "You took " + chain_label(k) + " back out of your plan.";
    did_warn = false;
};

/// guess menu -> back to planning
back_to_plan = function() {
    state    = "pick";
    pick     = -1;
    did      = "You can change your plan now.";
    did_warn = false;
};

/// words on the big bottom button
go_label = function() {
    if (state == "intro")  return "Start";
    if (state == "choose") return "Show me what happens";
    if (result_on) {
        if (is_choice) return has_next_level() ? "Next level" : "See my score";
        return (kind == "win") ? "Next one" : "Try again";
    }
    if (state == "anim") return "Watch...";
    return is_choice ? "I'm ready to guess" : "Check what happens";
};

/// can the big bottom button be pressed right now?
go_ready = function() {
    if (state == "intro")  return true;
    if (state == "choose") return pick >= 0;
    if (state == "anim")   return result_on;
    if (state == "pick")   return array_length(chain) > 0;
    return false;
};

/// the help box: what just happened (did) and what to do next (next).
/// dir says where to look: "up" = the round buttons, "down" = the big button.
guide_now = function() {
    var g = { did : did, warn : did_warn, next : "", dir : "" };
    switch (state) {
        case "pick": {
            var n = array_length(chain);
            if (n == 0) {
                g.next = "Tap a round button to add it to your plan.";
                g.dir  = "up";
            } else if (n >= array_length(sc.spots)) {
                g.next = "Your plan is done. Press I'm ready to guess.";
                g.dir  = "down";
            } else {
                g.next = "Tap another round button, or press I'm ready to guess.";
                g.dir  = "down";
            }
        } break;
        case "choose": {
            if (pick < 0) {
                g.next = "Tap the ending you think will happen.";
            } else {
                g.next = "Press Show me what happens. (Or tap a different one.)";
                g.dir  = "down";
            }
        } break;
        case "anim": {
            var total = array_length(chain);
            var step  = min(total, (anim_i div 2) + 1);
            var line  = "";
            if (step >= 1 && step <= total) {
                var k = chain[step - 1];
                line = variable_struct_exists(sc.describe, k) ? sc.describe[$ k] : chain_label(k);
            }
            g.next = "Watch step " + string(step) + " of " + string(total) + ": " + line;
        } break;
    }
    return g;
};

/// takes the chosen guess, works out what happens, and saves it
submit_choice = function() {
    ending        = choice_ending(sc, chain);
    kind          = choice_plan_key(chain);
    outcome_score = score_choice(sc, ending, pick);
    log_choice(sc, chain, pick, ending, outcome_score);   // written to disk right here
    anim      = build_choice_animation(sc, chain, ending, places);
    anim_i    = 0;
    anim_t    = 0;
    result_on = false;
    state     = "anim";
    did       = "You guessed number " + string(pick + 1) + ". Your guess is saved.";
    did_warn  = false;
};

/// the ending panel just came up: the points float up to the score box
on_result = function() {
    result_t = 0;
    if (is_choice && outcome_score != undefined) {
        array_push(fx, { type : "float", t : 0, dur : 70, x : SCR_W - 139, y : 62,
                         text : "+" + string(outcome_score.xp), col : ui_colours().gold });
    }
};

/// takes the typed guess, works out what happens, and saves it
submit_guess = function() {
    kind  = classify_outcome(sc, chain);
    outcome_score = score_attempt(sc, chain, guess, kind);
    log_attempt(sc, chain, guess, kind, outcome_score);   // written to disk right here
    anim      = build_animation(sc, chain, kind, places);
    anim_i    = 0;
    anim_t    = 0;
    result_on = false;
    state     = "anim";
};

/// resets the room to how it started
reset_scene = function() {
    chain     = [];
    chip_born = [];
    fx        = [];
    hop       = {};
    state     = "pick";
    guess     = "";
    kind      = "";
    outcome_score = undefined;
    anim      = [];
    anim_i    = 0;
    anim_t    = 0;
    act_key   = "";
    say       = "";
    result_on = false;
    pick      = -1;
    ending    = undefined;
    px        = home_x;
    py        = home_y;
    did       = is_choice ? "Try again! Make a new plan." : "";
    did_warn  = false;
};
