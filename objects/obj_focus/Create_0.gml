/// Pick what the session is about.
game_init();

t     = 0;
typed = "";
msg   = "";
keyboard_string = "";

tag_w = 260;
tag_h = 150;
tag_y = 280;

tag_rect = function(i) {
    var cx = SCR_W * 0.5 + (i - 1.5) * (tag_w + 30);
    return [cx - tag_w * 0.5, tag_y, cx + tag_w * 0.5, tag_y + tag_h];
};
