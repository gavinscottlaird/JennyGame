t++;

var mx = ui_mx();
var my = ui_my();

if (ui_click()) {
    if (hit_rect(mx, my, rect_play))  room_goto(rm_char);
    if (hit_rect(mx, my, rect_score)) room_goto(rm_summary);
}
