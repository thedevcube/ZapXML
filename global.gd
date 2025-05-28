extends Node

var warning_used = false
##The required variables
var required_init_vars = {}
## user/documents/zapxml temporary folder
var document_folder: String = (OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/ZapXML_temporary_data/")
## user/documents/zapxml temporary folder/loop_data
var zap_folder_loop: String = (OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/ZapXML_temporary_data/loop_data/")

func _ready():
	check_for_main_folder()

## Checks if the main folder exists
## First we set a var with the path
func check_for_main_folder():
	print("Checking for folders..")
	print_rich('[color=#FFEA00]Document folder variable is: "' + Global.document_folder + '"[/color]')
	if not DirAccess.dir_exists_absolute(Global.document_folder):
		print("No ZapXML_data folder in documents, trying to create one...")
		DirAccess.make_dir_recursive_absolute(Global.document_folder)
		DirAccess.make_dir_absolute(Global.zap_folder_loop)

func exitconfirm(button):
	if button == 0:
		Input.set_default_cursor_shape(Input.CURSOR_WAIT)
		var dir = DirAccess.open(zap_folder_loop)
		for file in dir.get_files():
			dir.remove(file)
		DirAccess.remove_absolute(zap_folder_loop)
		DirAccess.remove_absolute(document_folder)
		print_rich('[color=#9655c6]ZapXML folder deleted.')
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		get_tree().quit()

func _notification(what: int) -> void:
## If the user wants to close, first delete our temporary folder and then exit
	if what == NOTIFICATION_WM_CLOSE_REQUEST: 
		DisplayServer.dialog_show("Confirm" , "Are you sure you want to exit? none of your loops or init will be saved.", PackedStringArray(["Yes" , "No"]) , exitconfirm)

func show_warning(message: String):
	var warning_scene = preload("res://instances/UI/warning.scn").instantiate()
	get_tree().current_scene.add_child(warning_scene)
	warning_scene.show_message(message)
