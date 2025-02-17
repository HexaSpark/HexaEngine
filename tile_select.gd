extends TextureRect

@export var SIZE: Vector2i = Vector2i(8, 8);
@export var COUNT: Vector2i = Vector2i(2, 2);
@export_range (1, 32) var SCALE: int = 1;
@onready var img: Image = Image.create_empty(SIZE.x * COUNT.x, SIZE.y * COUNT.y, false, Image.FORMAT_RGB8);
var mouse_pos: Vector2 = Vector2.ZERO;

var tile_index: int = 0;

func apply_buffer():
	var scaled_img = Image.create_from_data(
		SIZE.x * COUNT.x, SIZE.y * COUNT.y, false, Image.FORMAT_RGB8,
		img.get_data()
	)
	
	scaled_img.resize(SIZE.x * COUNT.x * SCALE, SIZE.y * COUNT.y * SCALE, Image.INTERPOLATE_NEAREST);
	
	texture = ImageTexture.create_from_image(scaled_img)

func _ready() -> void:
	apply_buffer()

func _process(delta: float) -> void:
	apply_buffer()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var scaled_pos: Vector2 = Vector2(mouse_pos);
		scaled_pos.x = floor(scaled_pos.x / SIZE.x);
		scaled_pos.y = floor(scaled_pos.y / SIZE.y);
		print(scaled_pos);
	elif event is InputEventMouseMotion:
		mouse_pos = event.position
