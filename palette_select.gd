extends TextureRect

@onready var color_rect: ColorRect = $ColorRect;

@export var SIZE: Vector2 = Vector2(8, 8);
@export_range (1, 32) var SCALE: int = 1;
@onready var img: Image = Image.create_empty(SIZE.x, SIZE.y, false, Image.FORMAT_RGB8)
@onready var outline: Image

var mouse_pos: Vector2 = Vector2.ZERO;

func apply_buffer():
	var scaled_img = Image.create_from_data(
		SIZE.x, SIZE.y, false, Image.FORMAT_RGB8,
		img.get_data()
	)
	
	scaled_img.resize(SIZE.x * SCALE, SIZE.y * SCALE, Image.INTERPOLATE_NEAREST);
	
	scaled_img.blend_rect(Global.gen_transparent(Vector2(SCALE, SCALE)), Rect2i(0, 0, SCALE, SCALE), Vector2i(0, 0))
	
	var sel_clr: Array = Global.palette_data[Global.get_color_idx(Global.color_selected, SIZE)];
	var outline_clr: Color = Global.get_rgb565_contrast_color(sel_clr)
	
	scaled_img.fill_rect(Rect2i(
		Global.color_selected.x * SCALE, Global.color_selected.y * SCALE,
		SCALE, 1
	), outline_clr);
	
	scaled_img.fill_rect(Rect2i(
		Global.color_selected.x * SCALE, Global.color_selected.y * SCALE + SCALE - 1,
		SCALE, 1
	), outline_clr);
	
	scaled_img.fill_rect(Rect2i(
		Global.color_selected.x * SCALE, Global.color_selected.y * SCALE,
		1, SCALE
	), outline_clr);
	
	scaled_img.fill_rect(Rect2i(
		Global.color_selected.x * SCALE + SCALE - 1, Global.color_selected.y * SCALE,
		1, SCALE
	), outline_clr);
	
	#scaled_img.fill_rect(Rect2i(
		#Global.color_selected.x * SCALE, Global.color_selected.y * SCALE,
		#SCALE, SCALE,
	#), outline_clr)
	#
	#scaled_img.fill_rect(Rect2i(
		#Global.color_selected.x * SCALE + 1, Global.color_selected.y * SCALE + 1,
		#SCALE - 2, SCALE - 2,
	#), Global.rgb565_to_rgb888(sel_clr[0], sel_clr[1], sel_clr[2]))
	
	texture = ImageTexture.create_from_image(scaled_img)
	
func do_img():
	if !Global.palette_selectable and !color_rect.visible:
		color_rect.show();
	elif Global.palette_selectable and color_rect.visible:
		color_rect.hide();
	for sy in range(SIZE.y):
		for sx in range(SIZE.x):
			var idx = sy * SIZE.x + sx
			var color_info = Global.palette_data[idx]
			
			img.set_pixel(sx, sy, Global.rgb565_to_rgb888(color_info[0], color_info[1], color_info[2]))
			
	apply_buffer()

func _ready() -> void:
	Global.palette_size = SIZE;
	color_rect.size = Vector2i(SIZE.x * SCALE, SIZE.y * SCALE)
	color_rect.hide();
	
	do_img()
	
func _process(_delta):
	do_img()

func _on_gui_input(event: InputEvent) -> void:
	if !Global.palette_selectable:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var scaled_pos: Vector2 = Vector2(mouse_pos);
		scaled_pos.x = floor(scaled_pos.x / SCALE);
		scaled_pos.y = floor(scaled_pos.y / SCALE);
		Global.color_selected = scaled_pos;
	elif event is InputEventMouseMotion:
		mouse_pos = event.position
