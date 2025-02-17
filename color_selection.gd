extends MarginContainer

signal update_color(value: int)

@export_range(0, 63) var value = 0;
@export_range(0, 63) var max_value = 31;

@onready var text: SpinBox = $ControlHBox/Text;
@onready var slider: HSlider = $ControlHBox/Slider;

func update_value(new_value: int, send_signal: bool = true) -> void:
	var actual_value: int = new_value;
	
	if new_value > max_value:
		actual_value = max_value;
	
	if send_signal:
		text.value = actual_value;
		slider.value = actual_value;
	else:
		text.set_value_no_signal(actual_value);
		slider.set_value_no_signal(actual_value);

func _ready() -> void:
	text.max_value = max_value;
	slider.max_value = max_value;
	update_value(value);

func _on_value_changed(value: float) -> void:
	value = int(floor(value))
	update_value(value)
	update_color.emit(value)
