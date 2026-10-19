/// scr_state -- who is playing, what they have done, and saving it safely.
///
/// SAVE PERSISTENCE (the third flagged pitfall)
/// The log is written to disk the moment anything happens -- when a name is
/// entered, a focus is picked, a prediction is typed and an outcome is shown --
/// NOT when the arrow button is finally pressed. If the app closes without
/// warning, everything up to the last action is already on disk.
/// The file lives in the game's own save area, which GameMaker names after the
/// project:
///   %LOCALAPPDATA%\JennyGame\pps_log.json
/// It is plain JSON: one record per player name, each with total XP and every
/// attempt (chain, prediction, outcome, XP and the reason).

#macro SAVE_FILE "pps_log.json"
#macro SAVE_VERSION 1

/// @desc Sets up globals and loads any earlier log. Safe to call twice.
function game_init() {
    if (variable_global_exists("pps_ready")) return;
    global.pps_ready = true;

    // everything is drawn in GUI space at one fixed size, so the layout in
    // scr_config lines up whatever the window is doing
    display_set_gui_size(SCR_W, SCR_H);
    gpu_set_tex_filter(false);          // keep the pixels sharp, not blurry
    draw_set_font(fnt_pix);

    global.data = load_log();
    global.cur  = {
        name   : "",
        char   : "robot",
        focus  : "",
        flabel : "",
        sindex : 0,          // which scenario of the focus we are on
        session_xp : 0,
        session_n  : 0
    };
}

/// @desc Reads the log file. Returns a fresh record if there is nothing to read.
function load_log() {
    var fresh = { version : SAVE_VERSION, players : {} };
    if (!file_exists(SAVE_FILE)) return fresh;

    var f = file_text_open_read(SAVE_FILE);
    if (f < 0) return fresh;
    var txt = "";
    while (!file_text_eof(f)) {
        txt += file_text_read_string(f);
        file_text_readln(f);
    }
    file_text_close(f);

    if (str_trim(txt) == "") return fresh;
    try {
        var d = json_parse(txt);
        if (!is_struct(d) || !variable_struct_exists(d, "players")) return fresh;
        return d;
    } catch (_e) {
        // a damaged file must never stop a session: start clean but keep the
        // broken one around so it can be looked at later
        if (file_exists(SAVE_FILE + ".bad")) file_delete(SAVE_FILE + ".bad");
        file_copy(SAVE_FILE, SAVE_FILE + ".bad");
        return fresh;
    }
}

/// @desc Writes the whole log to disk. Called after every single action.
function save_log() {
    if (!variable_global_exists("data")) return;
    var f = file_text_open_write(SAVE_FILE);
    if (f < 0) return;
    file_text_write_string(f, json_stringify(global.data));
    file_text_close(f);
}

/// @desc Tidies a typed name so it works as a tag and as a save key.
function clean_name(txt) {
    var s = str_trim(txt);
    if (string_length(s) > 12) s = string_copy(s, 1, 12);
    return s;
}

/// @desc The saved record for a player, made on first use.
function player_record(name) {
    if (name == "") name = "Player";
    if (!variable_struct_exists(global.data.players, name)) {
        global.data.players[$ name] = {
            name    : name,
            avatar  : global.cur.char,
            xp      : 0,
            plays   : 0,
            entries : []
        };
    }
    return global.data.players[$ name];
}

/// @desc Every player name that has a record, oldest first.
function player_names() {
    return variable_struct_get_names(global.data.players);
}

/// @desc Remembers who is playing, as soon as they pick. Saves at once.
function set_player(name, char_key) {
    global.cur.name = clean_name(name);
    global.cur.char = char_key;
    var rec = player_record(global.cur.name);
    rec.avatar = char_key;
    save_log();
}

/// @desc Remembers the chosen focus. Saves at once.
function set_focus(fkey, flabel) {
    global.cur.focus  = fkey;
    global.cur.flabel = flabel;
    global.cur.sindex = 0;
    save_log();
}

/// @desc Writes one attempt into the log and saves straight away.
/// @param {Struct} sc      scenario
/// @param {Array} chain    buttons pressed
/// @param {String} pred    what was typed
/// @param {String} kind    ending
/// @param {Struct} score   result from score_attempt
function log_attempt(sc, chain, pred, kind, score) {
    var rec = player_record(global.cur.name);
    var words = "";
    for (var i = 0; i < array_length(chain); i++) {
        words += (i > 0 ? " > " : "") + chain_label(chain[i]);
    }

    array_push(rec.entries, {
        when    : date_datetime_string(date_current_datetime()),
        focus   : global.cur.flabel,
        goal    : sc.goal,
        tier    : sc.tier,
        tier_name : sc.tier_name,
        chain   : chain,
        chain_words : words,
        guess   : pred,
        outcome : kind,
        said    : outcome_text(sc, kind),
        xp      : score.xp,
        credit  : score.credit,
        why     : score.why
    });
    rec.xp    += score.xp;
    rec.plays += 1;
    rec.avatar = global.cur.char;

    global.cur.session_xp += score.xp;
    global.cur.session_n  += 1;

    save_log();                      // <- on disk before the player can quit
}

/// @desc The word shown for an object in the chain at the top of the screen.
function chain_label(key) {
    var A = art_objects();
    if (variable_struct_exists(A, key)) return A[$ key].label;
    return key;
}

/// @desc Total XP for the player who is playing now.
function current_xp() {
    if (global.cur.name == "") return 0;
    var p = global.data.players;
    if (!variable_struct_exists(p, global.cur.name)) return 0;
    return p[$ global.cur.name].xp;
}

/// @desc Sends the player back to the start of the game, keeping the log.
function end_session() {
    save_log();
    room_goto(rm_summary);
}

/// @desc The situation line with the player's name in it.
function situation_text(sc) {
    var nm = (global.cur.name == "") ? "Your character" : global.cur.name;
    return string_replace_all(sc.goal, "{name}", nm);
}

/// @desc Writes one attempt at a choice level into the log and saves at once.
function log_choice(sc, chain, pick, ending, result) {
    var rec = player_record(global.cur.name);
    var words = "";
    for (var i = 0; i < array_length(chain); i++) {
        words += (i > 0 ? " > " : "") + chain_label(chain[i]);
    }

    array_push(rec.entries, {
        when        : date_datetime_string(date_current_datetime()),
        focus       : global.cur.flabel,
        goal        : situation_text(sc),
        tier        : sc.tier,
        tier_name   : sc.tier_name,
        chain       : chain,
        chain_words : words,
        guess       : sc.predict[pick],
        right_guess : sc.predict[ending.pick],
        outcome     : choice_plan_key(chain),
        result_word : result.word,
        said        : ending.text,
        xp          : result.xp,
        credit      : result.credit,
        why         : result.why
    });
    rec.xp    += result.xp;
    rec.plays += 1;
    rec.avatar = global.cur.char;

    global.cur.session_xp += result.xp;
    global.cur.session_n  += 1;

    save_log();
}
