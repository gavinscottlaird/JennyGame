/// scr_scene_util -- placing the room objects and picking which scenario runs.

#macro ROW_A_Y 230          // back row of objects
#macro ROW_B_Y 420          // front row (only used when a room has 5 or 6 things)

/// @desc The scenario the player is on right now.
function current_scenario() {
    var list = scenario_list(global.cur.focus);
    if (array_length(list) == 0) list = scenario_list("school");
    var i = clamp(global.cur.sindex, 0, array_length(list) - 1);
    return list[i];
}

/// @desc Positions in the list of every scenario whose level (tier) is `tier`.
function level_pool(list, tier) {
    var pool = [];
    for (var i = 0; i < array_length(list); i++) {
        if (list[i].tier == tier) array_push(pool, i);
    }
    return pool;
}

/// @desc Picks one scenario at random from a level (tier), or -1 if there is none.
function pick_level_index(list, tier) {
    var pool = level_pool(list, tier);
    if (array_length(pool) == 0) return -1;
    return pool[irandom(array_length(pool) - 1)];
}

/// @desc Moves on to the next scenario. In Jenny's levels that means a random
/// scenario from the next level up; the old focuses just step down the list.
function next_scenario() {
    var list = scenario_list(global.cur.focus);
    if (array_length(list) == 0) return;
    if (global.cur.focus == "levels") {
        var cur_tier = list[clamp(global.cur.sindex, 0, array_length(list) - 1)].tier;
        var nxt = pick_level_index(list, cur_tier + 1);
        if (nxt >= 0) global.cur.sindex = nxt;
        save_log();
        return;
    }
    global.cur.sindex = (global.cur.sindex + 1) % array_length(list);
    save_log();
}

/// @desc True when there is another level after this one (no looping round).
function has_next_level() {
    var list = scenario_list(global.cur.focus);
    if (global.cur.focus == "levels") {
        var cur_tier = list[clamp(global.cur.sindex, 0, array_length(list) - 1)].tier;
        return array_length(level_pool(list, cur_tier + 1)) > 0;
    }
    return global.cur.sindex < array_length(list) - 1;
}

/// @desc Spreads object keys evenly across a row.
function spread_row(keys, y_top, into) {
    var c = array_length(keys);
    if (c == 0) return;
    var left = 170, right = SCR_W - 170;
    for (var i = 0; i < c; i++) {
        var cx = SCR_W * 0.5;
        if (c > 1) cx = left + (right - left) * (i / (c - 1));
        into[$ keys[i]] = {
            x  : cx,                      // centre of the art
            y  : y_top,                   // top of the art
            bx : cx,                      // centre of the round button
            by : y_top - BTN_LIFT
        };
    }
}

/// @desc Works out where every object in a scenario sits, so no two action
///       buttons can ever touch. Up to four things go in one row; five or six
///       split across two rows.
function layout_positions(spots) {
    var places = {};
    var n = array_length(spots);
    if (n <= 4) {
        spread_row(spots, ROW_A_Y, places);
    } else {
        var half = ceil(n / 2);
        var a = [], b = [];
        for (var i = 0; i < n; i++) {
            if (i < half) array_push(a, spots[i]); else array_push(b, spots[i]);
        }
        spread_row(a, ROW_A_Y, places);
        spread_row(b, ROW_B_Y, places);
    }
    return places;
}

/// @desc Rectangles the name tag has to keep clear of: every action button
///       (plus room for its tooltip) and every piece of object art.
function scene_avoid_rects(spots, places) {
    var out = [];
    for (var i = 0; i < array_length(spots); i++) {
        var p = places[$ spots[i]];
        array_push(out, [p.bx - BTN_R - 6, p.by - BTN_R - 6, p.bx + BTN_R + 6, p.by + BTN_R + 34]);
        array_push(out, [p.x - OBJ_W * 0.5, p.y, p.x + OBJ_W * 0.5, p.y + OBJ_H]);
    }
    return out;
}

/// @desc How many times a key already appears in the chain.
function chain_count(chain, key) {
    var n = 0;
    for (var i = 0; i < array_length(chain); i++) if (chain[i] == key) n++;
    return n;
}
