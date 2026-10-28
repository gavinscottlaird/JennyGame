/// scr_config -- one place for every size, colour and screen position.
/// The UI spec in the design doc is encoded here, so Luna can retune the look
/// without hunting through the game code.

// ---- version label, shown on the title screen ----
// Change this with every game change, so whoever is testing can see at a
// glance that they opened the newest copy.
#macro GAME_VERSION "Version: Oct 27 - more Level 1 scenarios"

// ---- screen ----
#macro SCR_W 1366
#macro SCR_H  768

// ---- art scale ----
#macro CHAR_SCALE 5                      // 16 x 20 grid  ->  80 x 100 on screen
#macro OBJ_SCALE  5                      // 16 x 16 grid  ->  80 x 80 on screen
#macro CHAR_W (CHAR_GRID_W * CHAR_SCALE)
#macro CHAR_H (CHAR_GRID_H * CHAR_SCALE)
#macro OBJ_W  (OBJ_GRID * OBJ_SCALE)
#macro OBJ_H  (OBJ_GRID * OBJ_SCALE)

// ---- action buttons (spec: 60px circles, #FFD700, white icon, tooltip below) ----
#macro BTN_R        30                   // 60px across
#macro BTN_LIFT     52                   // how far the button floats above the art
#macro BTN_MAX       6                   // most objects a room may hold

// ---- fixed screen furniture ----
#macro CHAIN_Y       68                  // the plan sits along the top (second line)
#macro ROOM_TOP      96
#macro ROOM_BOT     656
#macro FLOOR_Y      600                  // where the characters' feet walk
#macro BAR_Y        664                  // bottom bar starts here

#macro GO_W         420                  // "Check what happens" button
#macro GO_H          64
#macro GO_X    ((SCR_W - GO_W) * 0.5)
#macro GO_Y         684

#macro END_X         24                  // bottom-left square: end the session
#macro END_Y        692
#macro END_S         52

#macro REW_X       1318                  // bottom-right circle: time machine
#macro REW_Y        718
#macro REW_R         28


/// @desc The game's colours. Built once, kept in a global.
function ui_colours() {
    if (variable_global_exists("ui_col")) return global.ui_col;
    global.ui_col = {
        gold      : make_colour_rgb(255, 215,   0),   // #FFD700, spec colour for buttons
        gold_dark : make_colour_rgb(198, 160,   0),
        wall      : make_colour_rgb( 42,  49,  87),
        wall_lo   : make_colour_rgb( 33,  39,  71),
        floor     : make_colour_rgb( 92,  74,  62),
        floor_lo  : make_colour_rgb( 74,  59,  50),
        sky       : make_colour_rgb( 30,  35,  64),
        panel     : make_colour_rgb(245, 241, 230),
        panel_lo  : make_colour_rgb(214, 208, 194),
        ink       : make_colour_rgb( 27,  27,  42),
        white     : make_colour_rgb(252, 250, 244),
        good      : make_colour_rgb(110, 203,  99),
        bad       : make_colour_rgb(232,  99,  90),
        cool      : make_colour_rgb( 96, 178, 232),
        tag       : make_colour_rgb( 26,  30,  50),
        shade     : make_colour_rgb(  0,   0,   0)
    };
    return global.ui_col;
}

/// @desc Screen rectangle of the fixed "Check what happens" button.
function rect_go()  { return [GO_X, GO_Y, GO_X + GO_W, GO_Y + GO_H]; }

/// @desc Screen rectangle of the bottom-left end-session button.
function rect_end() { return [END_X, END_Y, END_X + END_S, END_Y + END_S]; }

/// @desc Screen rectangle of the full-screen button (top-right, every screen).
function rect_fs()  { return [SCR_W - 50, 10, SCR_W - 14, 42]; }
