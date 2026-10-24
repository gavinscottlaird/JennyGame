var mx    = ui_mx();
var my    = ui_my();
var click = ui_click();

var rec = shown_record();
var n   = (rec == undefined) ? 0 : array_length(rec.entries);

// scrolling the log
var view_h = list_bot - list_top;
var max_s  = max(0, n * ENTRY_H - view_h);
if (mouse_wheel_down()) scroll += 60;
if (mouse_wheel_up())   scroll -= 60;
if (keyboard_check(vk_down)) scroll += 10;
if (keyboard_check(vk_up))   scroll -= 10;
// drag the list with the mouse held down
if (mouse_check_button_pressed(mb_left) && my > list_top && my < list_bot) {
    dragging = true;
    last_my  = my;
}
if (!mouse_check_button(mb_left)) dragging = false;
if (dragging) {
    scroll -= (my - last_my);
    last_my = my;
}
scroll = clamp(scroll, 0, max_s);

if (click) {
    if (hit_rect(mx, my, rect_menu) || hit_rect(mx, my, rect_end())) {
        room_goto(rm_menu);
        exit;
    }
    if (hit_rect(mx, my, rect_again)) {
        room_goto(rm_char);
        exit;
    }
    if (array_length(names) > 1) {
        if (hit_rect(mx, my, rect_prev)) {
            idx = (idx - 1 + array_length(names)) % array_length(names);
            scroll = 0;
        }
        if (hit_rect(mx, my, rect_next)) {
            idx = (idx + 1) % array_length(names);
            scroll = 0;
        }
    }
}
