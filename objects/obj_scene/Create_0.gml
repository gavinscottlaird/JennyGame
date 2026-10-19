/// The playing screen: walk about, build a chain, guess, watch what happens.
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

// ---- choice levels (Jenny's levels): guess from a menu of four ----
is_choice = variable_struct_exists(sc, "mode") && sc.mode == "choice";
pick      = -1;             // which of the four endings the student chose
ending    = undefined;      // the ending that played
if (is_choice) {
    state    = "intro";     // show the situation card first
    sit_text = situation_text(sc);
}

/// screen box of guess number i in the menu
choice_rect = function(i) {
    var w = 1100, h = 66, gap = 10, top = 214;
    var x1 = (SCR_W - w) * 0.5;
    var y1 = top + i * (h + gap);
    return [x1, y1, x1 + w, y1 + h];
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
};
