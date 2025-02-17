extends MenuBar

@onready var about_window: Window = $"../AboutWindow"
@onready var open_file_window: FileDialog = $"../OpenFileWindow"
@onready var save_file_window: FileDialog = $"../SaveFileWindow"
@onready var export_window: Window = $"../ExportWindow"

enum FileIDs {
	New = 0,
	Open = 1,
	Save = 2,
	Exit = 3,
	Export = 4,
}

enum SettingsIDs {
	Scale_1x = 1,
	Scale_2x = 2,
	test = 3,
}

enum HelpIDs {
	About = 0,
}

func _ready() -> void:
	for raw_child in get_children():
		var child: PopupMenu = raw_child;
		child.connect("id_pressed", Callable.create(self, "pressed").bind(child))
		
func pressed(id: int, menu: PopupMenu):
	match menu.name:
		"File":
			var id_t = id as FileIDs;
			
			match id_t:
				FileIDs.New:
					print("New not implemented yet")
				FileIDs.Open:
					var f_selected = func (path: String):
						print("Open file path: {0}".format([path]))
					
					open_file_window.connect("file_selected", f_selected)
					open_file_window.popup_centered()
					open_file_window.disconnect("file_selected", f_selected)
				FileIDs.Save:
					var f_selected = func (path: String):
						print("Save file path: {0}".format([path]))
					
					save_file_window.connect("file_selected", f_selected)
					save_file_window.popup_centered()
					save_file_window.disconnect("file_selected", f_selected)
				FileIDs.Export:
					export_window.popup_centered();
				FileIDs.Exit:
					get_tree().quit()
		"Settings":
			var id_t = id as SettingsIDs;
			
			match id_t:
				SettingsIDs.Scale_1x:
					Global.change_scale(1)
				SettingsIDs.Scale_2x:
					Global.change_scale(2)
				SettingsIDs.test:
					$"../Window/TextureRect".texture = ImageTexture.create_from_image(Global.rom_data)
					$"../Window".size = Vector2($"../Window/TextureRect".size.x * 4, 200);
					$"../Window".popup_centered();
		"Help":
			var id_t = id as HelpIDs;
			
			match id_t:
				HelpIDs.About:
					about_window.popup_centered()
		
