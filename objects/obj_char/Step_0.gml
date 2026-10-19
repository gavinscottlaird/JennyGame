t++;

var mx    = device_mouse_x_to_gui(0);
var my    = device_mouse_y_to_gui(0);
var click = mouse_check_button_pressed(mb_left);
var order = art_char_order();

// back to the title screen
if (click && hit_rect(mx, my, rect_end())) {
    room_goto(rm_menu);
    exit;
}

if (click) {
    for (var i = 0; i < array_length(order); i++) {
        if (hit_rect(mx, my, card_rect(i))) {
            sel    = order[i];
            naming = true;
            keyboard_string = typed;        // keep anything already typed
            break;
        }
    }
}

if (naming) {
    if (string_length(keyboard_string) > 12) {
        keyboard_string = string_copy(keyboard_string, 1, 12);
    }
    typed = keyboard_string;

    var ready = (str_trim(typed) != "" && sel != "");
    if (ready && (keyboard_check_pressed(vk_enter)
                  || (click && hit_rect(mx, my, rect_start)))) {
        set_player(typed, sel);             // saved to disk straight away
        // Straight to Jenny's levels. The focus screen (rm_focus) and the 12
        // older scenarios are still in the project, just not used for now.
        set_focus("levels", "Levels");
        room_goto(rm_scene);
    }
}
