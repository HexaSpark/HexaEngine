extends TextureRect

@onready var transparent_bg: PanelContainer = $".."

@export var SIZE: Vector2 = Vector2(8, 8);
@export_range (1, 32) var SCALE: int = 1;
@onready var img: Image = Image.create_empty(SIZE.x, SIZE.y, false, Image.FORMAT_RGBA8)
var img_hash = 0;
var transparent_bg_texture: ImageTexture;
var button_down: bool = false;

var mouse_pos: Vector2 = Vector2.ZERO;

func hash_img(image: Image) -> int:
	return image.get_data().hex_encode().hash()

func apply_buffer():
	if img_hash == hash_img(img):
		return
		
	img_hash = hash_img(img)
	
	var scaled_img = Image.create_from_data(
		SIZE.x, SIZE.y, false, Image.FORMAT_RGBA8,
		img.get_data()
	)
	
	scaled_img.resize(SIZE.x * SCALE, SIZE.y * SCALE, Image.INTERPOLATE_NEAREST);
	
	texture = ImageTexture.create_from_image(scaled_img)
	
func gen_transparent_stylebox():
	var img = Global.gen_transparent(SIZE, SCALE);
	transparent_bg_texture = ImageTexture.create_from_image(img);
	var box = StyleBoxTexture.new();
	box.texture = transparent_bg_texture;
	transparent_bg.add_theme_stylebox_override("panel", box);
	
func plot_pixel():
	var scaled_pos: Vector2 = Vector2(mouse_pos);
	scaled_pos.x = floor(scaled_pos.x / SCALE);
	scaled_pos.y = floor(scaled_pos.y / SCALE);
	var sel_clr: Color;
	
	if Global.color_selected.is_zero_approx():
		sel_clr = Color8(0, 0, 0, 0);
	else:
		var raw_clr: Array = Global.palette_data[Global.get_color_idx(Global.color_selected, Global.palette_size)];
		sel_clr = Global.rgb565_to_rgb888(raw_clr[0], raw_clr[1], raw_clr[2]);
		
	img.set_pixel(scaled_pos.x, scaled_pos.y, sel_clr)
	
func _ready() -> void:
	gen_transparent_stylebox();
	
	for sy in range(SIZE.y):
		for sx in range(SIZE.x):
			var clr = Global.rgb565_to_rgb888(0, 0, 0);
			clr.a8 = 0;
			img.set_pixel(sx, sy, clr)
			
	apply_buffer()
	
func _process(_delta):
	apply_buffer()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			button_down = true;
			plot_pixel()
		else:
			button_down = false;
	elif event is InputEventMouseMotion:
		if button_down:
			plot_pixel()
		
		mouse_pos = event.position
