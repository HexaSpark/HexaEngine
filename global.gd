extends Node

var palette_data = [];
var color_selected: Vector2 = Vector2.ZERO;
var base_size: Vector2i = Vector2i(640, 360);
var settings: ConfigFile = ConfigFile.new();
var palette_selectable: bool = true;
var palette_size: Vector2 = Vector2.ZERO;

func load_settings():
	settings.load("user://settings.ini")
	
	change_scale(settings.get_value("Settings", "scale", 1));
	
func save_settings():
	settings.save("user://settings.ini")

func rgb565_to_rgb888(r: int, g: int, b: int) -> Color:
	r &= 0b11111
	g &= 0b111111
	b &= 0b11111
	
	return Color8(r << 3, g << 2, b << 3, 255)
	
func rgb565_to_int(rgb: Array) -> int:
	return ((rgb[0] << 11) | (rgb[1] << 5) | rgb[2])

func get_rgb565_contrast_color(color: Array) -> Color:
	var color_888 = rgb565_to_rgb888(color[0], color[1], color[2]);
	
	if (float(color_888.r8)*0.299 + float(color_888.g8)*0.587 + float(color_888.r8)*0.114) > 186:
		return Color.BLACK;
	else:
		return Color.WHITE;

func generate_default_palette():
	palette_data.clear()
	
	for r in range(0, 32, 4):
		for g in range(0, 64, 4):
			for b in range(0, 32, 4):
				palette_data.append([r, g, b])
				
	while len(palette_data) != 1024:
		palette_data.pop_back()

func get_color_idx(pos: Vector2, size: Vector2) -> int:
	return pos.y * size.x + pos.x

func change_scale(scale: int):
	get_tree().root.content_scale_factor = scale;
	get_window().size = base_size * scale;
	get_window().move_to_center()
	settings.set_value("Settings", "scale", scale);
	save_settings();
	
func gen_transparent(size: Vector2, scale: int = 1, color1: Color = Color8(0x8F, 0x8F, 0x8F), color2: Color = Color8(0xC0, 0xC0, 0xC0)) -> Image:
	var img = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGB8);
	var colors = [color1, color2];
	for sy in range(size.y):
		for sx in range(size.x):
			img.set_pixel(sx, sy, colors[0]);
			if sx != size.x - 1:
				colors.append(colors.pop_front());
	img.resize(size.x * scale, size.y * scale, Image.INTERPOLATE_NEAREST);
	
	return img

func _ready():
	generate_default_palette()
	load_settings();

func _process(_delta):
	DisplayServer.window_set_title(
		"HexaEngine - FPS: {fps}".format({
			"fps": Engine.get_frames_per_second()
		})
	)
