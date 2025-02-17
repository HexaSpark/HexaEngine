extends TextureRect

@export var SIZE: Vector2 = Vector2(8, 8);
@export_range (1, 32) var SCALE: int = 1;
	
func apply_buffer():
	var scaled_img = Image.create_from_data(
		SIZE.x, SIZE.y, false, Image.FORMAT_RGB8,
		Global.rom_data.get_data()
	)
	
	scaled_img.resize(SIZE.x * SCALE, SIZE.y * SCALE, Image.INTERPOLATE_NEAREST);
	
	texture = ImageTexture.create_from_image(scaled_img)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sy in range(0, 32):
		for sx in range(0, 32):
			Global.rom_data.set_pixel(sx, sy, Global.rgb565_to_rgb888(0, 0, 0));
	
	apply_buffer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apply_buffer()
