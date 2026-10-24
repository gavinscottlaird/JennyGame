/// End-of-session screen: total XP and the list of what happened.
game_init();

names = player_names();
idx   = 0;
for (var i = 0; i < array_length(names); i++) {
    if (names[i] == global.cur.name) idx = i;
}

scroll   = 0;
dragging = false;
last_my  = 0;
ENTRY_H  = 146;
list_top = 300;
list_bot = 662;

rect_menu  = [SCR_W * 0.5 - 330, 690, SCR_W * 0.5 - 30, 748];
rect_again = [SCR_W * 0.5 + 30,  690, SCR_W * 0.5 + 330, 748];
rect_prev  = [SCR_W - 150, 96, SCR_W - 100, 146];
rect_next  = [SCR_W - 86,  96, SCR_W - 36,  146];

/// the record being shown, or undefined when nobody has played yet
shown_record = function() {
    if (array_length(names) == 0) return undefined;
    return global.data.players[$ names[clamp(idx, 0, array_length(names) - 1)]];
};
