/// scr_smooth_art -- the new smooth, hand-drawn style pictures (Nov 2026).
///
/// The pictures are PNG files in datafiles/ (Included Files), named
///   art_char_<key>.png   avatars       (key from art_chars,   e.g. art_char_dino)
///   art_obj_<key>.png    room objects  (key from art_objects, e.g. art_obj_river)
///   art_bg_<name>.png    scene backgrounds
/// They are drawn from SVG source by tools/art/ (run: python3 tools/art/export.py).
///
/// Anything that has no PNG yet is drawn the old way, from its pixel map,
/// so old and new art can live side by side while the art set grows.
/// Set SMOOTH_ART_ON to false to go back to the old pixel art everywhere.

#macro SMOOTH_ART_ON true
#macro SMOOTH_W_GROW 1.5     // smooth art may be this much wider than the pixel canvas
#macro SMOOTH_H_GROW 1.1     // ...and this much taller (it grows upward from the feet)

/// @desc The sprite loaded from art_<name>.png, or -1 when there is no file.
///       Each file is only loaded once.
function smooth_spr(name) {
    if (!SMOOTH_ART_ON || name == "") return -1;
    if (!variable_global_exists("smooth_cache")) global.smooth_cache = {};
    if (variable_struct_exists(global.smooth_cache, name)) return global.smooth_cache[$ name];
    var spr  = -1;
    var file = "art_" + name + ".png";
    if (file_exists(file)) spr = sprite_add(file, 1, false, true, 0, 0);
    global.smooth_cache[$ name] = spr;
    return spr;
}

/// @desc Draws a sprite as big as fits in the box, centred, feet on `bottom`.
function draw_smooth_fit(spr, cx, bottom, maxw, maxh, alpha = 1, flip_v = false) {
    var w = sprite_get_width(spr), h = sprite_get_height(spr);
    var s = min(maxw / w, maxh / h);
    var tf = gpu_get_texfilter();
    gpu_set_texfilter(true);                  // smooth when scaled
    if (flip_v) draw_sprite_ext(spr, 0, cx - w * s * 0.5, bottom, s, -s, 0, c_white, alpha);   // grows up from `bottom`
    else        draw_sprite_ext(spr, 0, cx - w * s * 0.5, bottom - h * s, s,  s, 0, c_white, alpha);
    gpu_set_texfilter(tf);
}

/// @desc Draws an art entry (from art_chars or art_objects) in the box its
///       pixel map would fill: the smooth picture if there is one, otherwise
///       the pixel map. Same arguments as draw_pixel_map, but takes the entry.
function draw_art(entry, px, py, sc, alpha = 1, flip_v = false) {
    var cols = string_length(entry.map[0]);
    var rows = array_length(entry.map);
    var spr  = smooth_spr(variable_struct_exists(entry, "smooth") ? entry.smooth : "");
    if (spr < 0) {
        draw_pixel_map(entry.map, entry.pal, px, py, sc, alpha, flip_v);
        return;
    }
    draw_smooth_fit(spr, px + cols * sc * 0.5, py + rows * sc,
                    cols * sc * SMOOTH_W_GROW, rows * sc * SMOOTH_H_GROW, alpha, flip_v);
}

/// @desc One-colour icon of an art entry, centred on (cx, cy), at most `size` across.
///       Used for the white picture inside the round action buttons.
function draw_art_silhouette(entry, cx, cy, size, col, alpha = 1) {
    var spr = smooth_spr(variable_struct_exists(entry, "smooth") ? entry.smooth : "");
    if (spr < 0) {
        var isc = size / OBJ_GRID;
        draw_pixel_silhouette(entry.map, cx - OBJ_GRID * isc * 0.5, cy - OBJ_GRID * isc * 0.5, isc, col, alpha);
        return;
    }
    var w = sprite_get_width(spr), h = sprite_get_height(spr);
    var s = (size * 1.25) / max(w, h);
    gpu_set_fog(true, col, 0, 1);             // paint every pixel one colour
    var tf = gpu_get_texfilter();
    gpu_set_texfilter(true);
    draw_sprite_ext(spr, 0, cx - w * s * 0.5, cy - h * s * 0.5, s, s, 0, c_white, alpha);
    gpu_set_texfilter(tf);
    gpu_set_fog(false, c_black, 0, 0);
}

/// @desc Which background picture suits a scene, from the things in it.
function scene_bg_name(spots) {
    var has = function(list, keys) {
        for (var i = 0; i < array_length(list); i++)
            for (var j = 0; j < array_length(keys); j++)
                if (list[i] == keys[j]) return true;
        return false;
    };
    if (has(spots, ["river", "bush"]))   return "bg_meadow";
    if (has(spots, ["grass", "thorns"])) return "bg_meadow";
    if (has(spots, ["hill", "cave"]))    return "bg_hilltop";
    if (has(spots, ["shy", "group"]))    return "bg_forest";
    if (has(spots, ["swing", "bench", "ball"])) return "bg_meadow";
    return "bg_room";
}

/// @desc The playing screen's background: a smooth picture that fills the
///       window (cropped, never stretched), softened a little so the things
///       you can tap stand out. Falls back to the old wall-and-floor.
function draw_scene_backdrop(spots) {
    var spr = smooth_spr(scene_bg_name(spots));
    if (spr < 0) { draw_backdrop(true); return; }
    var L = ui_left(), R = ui_right(), T = ui_top(), B = ui_bottom();
    var w = sprite_get_width(spr), h = sprite_get_height(spr);
    var s = max((R - L) / w, (B - T) / h);
    var tf = gpu_get_texfilter();
    gpu_set_texfilter(true);
    draw_sprite_ext(spr, 0, (L + R) * 0.5 - w * s * 0.5, (T + B) * 0.5 - h * s * 0.5, s, s, 0, c_white, 1);
    gpu_set_texfilter(tf);
    draw_set_alpha(0.22);
    draw_set_colour(c_white);
    draw_rectangle(L, T, R, B, false);
    draw_set_alpha(1);
}
