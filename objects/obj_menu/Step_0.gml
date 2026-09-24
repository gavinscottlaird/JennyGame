t++;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    if (hit_rect(mx, my, rect_play))  room_goto(rm_char);
    if (hit_rect(mx, my, rect_score)) room_goto(rm_summary);
}
