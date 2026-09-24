/// scr_nametag -- the floating name tag over the player's head.
///
/// NAME TAG OVERLAP (the second flagged pitfall)
/// The tag never just sits above the head. It tries a list of spots in order
/// and takes the first one that is fully on screen and does not cover an
/// action button (or the button's tooltip strip). If every spot is blocked it
/// drops below the feet, where nothing else is drawn.

/// @desc Do two rectangles touch? Rectangles are [x1, y1, x2, y2].
function rect_overlap(a, b) {
    return !(a[2] < b[0] || a[0] > b[2] || a[3] < b[1] || a[1] > b[3]);
}

/// @desc Works out the tag rectangle and draws it.
/// @param {Real} cx        centre of the character
/// @param {Real} top_y     top of the character art
/// @param {Real} bot_y     bottom of the character art (the feet)
/// @param {String} name
/// @param {Array} avoid    rectangles the tag must not cover
/// @param {Bool} [prefer_below]  try under the feet first (when a gag is
///                               playing above the head)
function draw_name_tag(cx, top_y, bot_y, name, avoid, prefer_below = false) {
    if (name == "") return;
    var C  = ui_colours();
    var sc = 2;
    var tw = txt_w(name, sc);
    var w  = tw + 20;
    var h  = 26;

    // spots to try, best first: over the head, then shifted aside, then under the feet
    var tries = [
        [cx - w * 0.5, top_y - h - 12],
        [cx - w * 0.5 - (w * 0.6), top_y - h - 12],
        [cx - w * 0.5 + (w * 0.6), top_y - h - 12],
        [cx - w * 0.5, bot_y + 10]
    ];
    if (prefer_below) {
        tries = [
            [cx - w * 0.5, bot_y + 10],
            [cx - w * 0.5, top_y - h - 12],
            [cx - w * 0.5 - (w * 0.6), top_y - h - 12]
        ];
    }

    var bx = tries[0][0], by = tries[0][1], found = false;
    for (var i = 0; i < array_length(tries) && !found; i++) {
        var tx = clamp(tries[i][0], 8, SCR_W - w - 8);
        var ty = tries[i][1];
        if (ty < ROOM_TOP + 2) continue;               // would climb into the chain bar
        if (ty + h > ROOM_BOT + 40) continue;          // would fall into the bottom bar
        var r = [tx, ty, tx + w, ty + h];
        var clear = true;
        for (var a = 0; a < array_length(avoid); a++) {
            if (rect_overlap(r, avoid[a])) { clear = false; break; }
        }
        if (clear) { bx = tx; by = ty; found = true; }
    }
    if (!found) {
        // last resort: under the feet, clamped on screen
        bx = clamp(cx - w * 0.5, 8, SCR_W - w - 8);
        by = min(bot_y + 10, ROOM_BOT + 10);
    }

    // tag body, with a small point towards the character when it sits above
    draw_set_alpha(1);
    draw_set_colour(C.ink);
    draw_rectangle(bx - 3, by - 3, bx + w + 3, by + h + 3, false);
    draw_set_colour(C.tag);
    draw_rectangle(bx, by, bx + w, by + h, false);
    if (by + h < top_y) {
        var px = clamp(cx, bx + 10, bx + w - 10);
        draw_set_colour(C.ink);
        draw_triangle(px - 8, by + h, px + 8, by + h, px, by + h + 11, false);
        draw_set_colour(C.tag);
        draw_triangle(px - 5, by + h, px + 5, by + h, px, by + h + 7, false);
    }
    draw_txt(bx + w * 0.5, by + h * 0.5, name, sc, C.white, fa_center, fa_middle);
}
