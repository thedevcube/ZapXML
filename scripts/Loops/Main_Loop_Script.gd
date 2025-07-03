extends VBoxContainer
class_name loop_template
var data: Dictionary = {"event": "<Enter/>"}

@onready var loopnameref: TextEdit = $Loop_Container/loopname_containermargin/loopname
var loopeditor_scene = preload("res://instances/Loop/loop_editor.tscn")
@onready var root = $"."
var _loopname_window = ""


func _on_delete_button_button_down() -> void:
	# Delete me when the delete button is clicked
	self.queue_free()
# Delete the scn file if present
	if FileAccess.file_exists(Global.zap_folder_loop + self.name + ".scn"):
		DirAccess.remove_absolute(Global.zap_folder_loop + self.name + ".scn")


func loopname_set(_loopname , from_input = false):
	# Set the loop name on the title text when this func is called
	loopnameref = $Loop_Container/loopname_containermargin/loopname
	if from_input: name = "" if _loopname.is_empty() else (_loopname)
	if not from_input: name = _loopname; loopnameref.text = _loopname
	_loopname_window = _loopname

func _on_edit_button_button_down() -> void:
	# If clicking edit button, then open the loop editor interface.
	var lp: loop_editor = loopeditor_scene.instantiate()
	lp.check_for_duplicates = true
	root.add_child(lp)

	for i in root.get_child_count(): # checking if any other loop editor exists for this loop
		var node = root.get_child(i)
		if node.name == "loopeditor":
			lp.always_on_top = false
			OS.alert("You already have an loop editor open for this loop!" , "Loop editor warning")
			queue_free()
		else:
			return
	name = "loopeditor"

func _on_move_up_button_button_down() -> void:
	get_parent().move_child(self , self.get_index() - 1)

func _on_move_down_button_button_down() -> void:
	get_parent().move_child(self , self.get_index() + 1)


func on_namechange() -> void:
	loopname_set($Loop_Container/loopname_containermargin/loopname.text , true)
