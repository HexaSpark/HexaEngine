extends Window

func _ready() -> void:
	connect("close_requested", self.hide)
