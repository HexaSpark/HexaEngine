extends TextureRect

signal color_select(r: int, g: int, b: int);

@export var SIZE: Vector2i = Vector2(8, 8);
@export_range (1, 32) var SCALE: int = 1;
@onready var img: Image = Image.create_empty(SIZE.x, SIZE.y, false, Image.FORMAT_RGB8);
@onready var outline: Image;

var mouse_pos: Vector2 = Vector2.ZERO;
var palette_index: int = 1;

func idx_to_vec(idx: int) -> Vector2i:
	return Vector2i(idx % SIZE.x, floor(idx / SIZE.x))

func apply_buffer():
	var scaled_img = Image.create_from_data(
		SIZE.x, SIZE.y, false, Image.FORMAT_RGB8,
		img.get_data()
	);
	
	scaled_img.resize(SIZE.x * SCALE, SIZE.y * SCALE, Image.INTERPOLATE_NEAREST);
	
	scaled_img.blend_rect(Global.gen_transparent(Vector2(SCALE, SCALE)), Rect2i(0, 0, SCALE, SCALE), Vector2i(0, 0));
	
	var sel_clr: Array = Global.palette_data[palette_index];
	var outline_clr: Color = Global.get_rgb565_contrast_color(sel_clr);
	var clr_cords: Vector2i = idx_to_vec(palette_index);
	
	scaled_img.fill_rect(Rect2i(
		clr_cords.x * SCALE, clr_cords.y * SCALE,
		SCALE, 1
	), outline_clr);
	
	scaled_img.fill_rect(Rect2i(
		clr_cords.x * SCALE, clr_cords.y * SCALE + SCALE - 1,
		SCALE, 1
	), outline_clr);
	
	scaled_img.fill_rect(Rect2i(
		clr_cords.x * SCALE, clr_cords.y * SCALE,
		1, SCALE
	), outline_clr);
	
	scaled_img.fill_rect(Rect2i(
		clr_cords.x * SCALE + SCALE - 1, clr_cords.y * SCALE,
		1, SCALE
	), outline_clr);
	
	texture = ImageTexture.create_from_image(scaled_img);
	
func do_img():
	for sy in range(SIZE.y):
		for sx in range(SIZE.x):
			var idx = sy * SIZE.x + sx
			var color_info = Global.palette_data[idx];
			
			img.set_pixel(sx, sy, Global.rgb565_to_rgb888(color_info[0], color_info[1], color_info[2]));
			
	apply_buffer();

func _ready() -> void:
	do_img();
	
func _process(_delta):
	do_img();

func _on_gui_input(event: InputEvent) -> void:
	if !Global.palette_selectable:
		return; 
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var scaled_pos: Vector2 = Vector2(mouse_pos);
		scaled_pos.x = floor(scaled_pos.x / SCALE);
		scaled_pos.y = floor(scaled_pos.y / SCALE);
		
		if scaled_pos.is_zero_approx():
			scaled_pos.x = 1;
		
		palette_index = scaled_pos.y * SIZE.x + scaled_pos.x;
		var clr = Global.palette_data[palette_index];
		color_select.emit(clr[0], clr[1], clr[2])
	elif event is InputEventMouseMotion:
		mouse_pos = event.position;

func _on_controls_color_565_updated(r: int, g: int, b: int) -> void:
	Global.palette_data[palette_index] = [r, g, b];
