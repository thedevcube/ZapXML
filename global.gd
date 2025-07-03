extends Node
signal AOT_toggle

var volume = 1
var warning_used = false
##The required variables
var required_init_vars = {}
## user/documents/zapxml temporary folder
var document_folder: String = (OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/ZapXML_temporary_data/")
## user/documents/zapxml temporary folder/loop_data
var zap_folder_loop: String = (OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/ZapXML_temporary_data/loop_data/")
@export var script_holder: Node

func _ready():
	get_window().mode = Window.MODE_MAXIMIZED
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

func load_xml(text: String , node: Node):
	script_holder = node
	script_holder.load_xml_def(text)

func display_loop(node: Node , callable: Callable):
	for child in node.get_parent().get_children():
		if child.name.begins_with("loop name input"):
			child.queue_free()
	var ins = preload("res://instances/Popups/loop_input.scn").instantiate()
	node.get_parent().add_child(ins)
	ins.name = "loop name input"
	ins.position = get_viewport().get_mouse_position() - Vector2(172.0 , 0)
	ins.get_child(0).callback = callable
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("F11"):
		print("test")
		get_window().mode = Window.MODE_FULLSCREEN if get_window().mode != Window.MODE_FULLSCREEN else Window.MODE_WINDOWED

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes
