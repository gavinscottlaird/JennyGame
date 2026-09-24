/// scr_outcome -- decides what happened, and builds the little movie that shows it.

/// @desc Which ending does this chain lead to?
///       Returns one of: "win", "obsession", "wrong_order", "overload", "incomplete".
function classify_outcome(sc, chain) {
    var correct = sc.correct;
    var n = array_length(chain);
    var m = array_length(correct);

    if (n == 0) return "incomplete";

    // exactly right, in order
    if (n == m) {
        var same = true;
        for (var i = 0; i < m; i++) if (chain[i] != correct[i]) { same = false; break; }
        if (same) return "win";
    }

    // tier 1 trap: the same button over and over
    for (var i = 0; i < n; i++) {
        var c = 0;
        for (var j = 0; j < n; j++) if (chain[j] == chain[i]) c++;
        if (c >= 3) return "obsession";
    }

    // tier 3 trap: piling on more than the job needs
    if (n > m) return "overload";

    // everything needed is there, but jumbled
    if (n == m) return "wrong_order";

    // fewer steps than needed: is it a clean stop, or a muddle?
    var run = ordered_run(chain, correct);
    if (run == n) return "incomplete";
    return "wrong_order";
}

/// @desc The funny line for an ending.
function outcome_text(sc, kind) {
    if (kind == "win") return sc.win;
    if (variable_struct_exists(sc.fail, kind)) return sc.fail[$ kind];
    return sc.fail.incomplete;
}

/// @desc The ending in plain words, for the score screen and the log.
function outcome_word(kind) {
    switch (kind) {
        case "win"         : return "It worked";
        case "obsession"   : return "Same thing too much";
        case "wrong_order" : return "Out of order";
        case "overload"    : return "Too much at once";
        default            : return "Missed some steps";
    }
}

/// @desc The visual gag that plays with the line.
function outcome_gag(kind) {
    switch (kind) {
        case "win"         : return "cheer";
        case "obsession"   : return "pile";
        case "wrong_order" : return "spin";
        case "overload"    : return "fly";
        default            : return "wobble";
    }
}

/// @desc Builds the animation: walk to each button in turn, do the thing,
///       then hold on the ending.
/// @param {Struct} sc      scenario
/// @param {Array} chain    button keys in the order they were picked
/// @param {String} kind    ending from classify_outcome
/// @param {Struct} places  key -> { x, y } screen spot of each object
function build_animation(sc, chain, kind, places) {
    var steps = [];
    for (var i = 0; i < array_length(chain); i++) {
        var key = chain[i];
        var p   = { x : SCR_W * 0.5, y : FLOOR_Y };
        if (variable_struct_exists(places, key)) p = places[$ key];
        array_push(steps, { type : "walk", key : key, tx : p.x, frames : 50 });
        array_push(steps, { type : "act",  key : key, text : object_verb(key), frames : 24 });
    }
    array_push(steps, {
        type   : "result",
        kind   : kind,
        gag    : outcome_gag(kind),
        text   : outcome_text(sc, kind),
        frames : 9999                      // holds until the player rewinds
    });
    return steps;
}
