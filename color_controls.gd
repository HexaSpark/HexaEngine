extends VBoxContainer

signal color_updated(color: Color);
signal color_565_updated(r: int, g: int, b: int);

var r = 0;
var g = 0;
var b = 0;

func _on_red_update_color(value: int) -> void:
	r = value;
	color_updated.emit(Global.rgb565_to_rgb888(r, g, b));
	color_565_updated.emit(r, g, b);

func _on_green_update_color(value: int) -> void:
	g = value;
	color_updated.emit(Global.rgb565_to_rgb888(r, g, b));
	color_565_updated.emit(r, g, b);

func _on_blue_update_color(value: int) -> void:
	b = value;
	color_updated.emit(Global.rgb565_to_rgb888(r, g, b));
	color_565_updated.emit(r, g, b);

func _on_palette_edit_color_select(r: int, g: int, b: int) -> void:
	self.r = r;
	self.g = g;
	self.b = b;
	
	$RedControlMargin.update_value(r, false);
	$GreenControlMargin.update_value(g, false);
	$BlueControlMargin.update_value(b, false);
	
	color_updated.emit(Global.rgb565_to_rgb888(r, g, b));
	color_565_updated.emit(r, g, b);
	
