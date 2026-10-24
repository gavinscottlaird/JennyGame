/// Pick a helper, then type your name.
game_init();

t      = 0;
sel    = "";                    // which avatar is picked
sel_t  = 999;                   // frames since it was picked (the "Picked!" pop)
naming = false;
typed  = "";

// four cards, all the same size, because all four avatars are the same size
card_w = 200;
card_h = 300;
card_y = 200;

rect_start = [SCR_W * 0.5 - 130, 636, SCR_W * 0.5 + 130, 700];

card_rect = function(i) {
    var cx = SCR_W * 0.5 + (i - 1.5) * (card_w + 34);
    return [cx - card_w * 0.5, card_y, cx + card_w * 0.5, card_y + card_h];
};
