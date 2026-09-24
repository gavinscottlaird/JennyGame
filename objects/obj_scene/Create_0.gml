/// The playing screen: walk about, build a chain, guess, watch what happens.
game_init();

sc     = current_scenario();
places = layout_positions(sc.spots);
avoid  = scene_avoid_rects(sc.spots, places);

chain  = [];
state  = "pick";            // pick -> modal -> anim
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
    px        = home_x;
    py        = home_y;
};
