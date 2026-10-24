t++;

var mx    = ui_mx();
var my    = ui_my();
var click = ui_click();
var fl    = focus_list();

if (click && hit_rect(mx, my, rect_end())) {
    room_goto(rm_char);
    exit;
}

// tap a tag
if (click) {
    for (var i = 0; i < array_length(fl); i++) {
        if (hit_rect(mx, my, tag_rect(i))) {
            set_focus(fl[i].key, fl[i].label);
            room_goto(rm_scene);
            exit;
        }
    }
}

// or type a word
if (string_length(keyboard_string) > 20) {
    keyboard_string = string_copy(keyboard_string, 1, 20);
}
typed = keyboard_string;

if (keyboard_check_pressed(vk_enter) && str_trim(typed) != "") {
    var fkey = focus_from_text(typed);
    if (fkey == "") {
        msg = "I do not know that word. Try school, friends, home or food.";
    } else {
        for (var i = 0; i < array_length(fl); i++) {
            if (fl[i].key == fkey) {
                set_focus(fl[i].key, fl[i].label);
                room_goto(rm_scene);
                exit;
            }
        }
    }
}
