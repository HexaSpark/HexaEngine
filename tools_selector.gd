extends HBoxContainer

@onready var tools: Array[Button] = [$Pencil, $Eraser]

var selected_tool = "Pencil";
var prev_palette_position: Vector2 = Vector2.ZERO;

func get_tool(name: String) -> Button:
	for tool in tools:
		if tool.name == name:
			return tool
	return null

func _ready() -> void:
	for tool in tools:
		tool.connect("pressed", Callable.create(self, "handle_tool_click").bind(tool.name))

func handle_tool_click(c_tool: String):
	selected_tool = c_tool
	
	if c_tool == "Eraser":
		Global.palette_selectable = false;
		prev_palette_position = Global.color_selected;
		Global.color_selected = Vector2(0, 0);
	else:
		Global.palette_selectable = true;
		Global.color_selected = prev_palette_position;
	
	for tool in tools:
		if tool.name == selected_tool:
			tool.button_pressed = true;
		else:
			tool.button_pressed = false;
