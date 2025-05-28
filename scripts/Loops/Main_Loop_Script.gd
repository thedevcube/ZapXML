extends VBoxContainer

@onready var loopnameref = $Loop_Container/loopname_containermargin/loopname
var loopeditor_scene = preload("res://instances/Loop/loop_editor.tscn")
@onready var root = $"."
var _loopname_window = ""


func _on_delete_button_button_down() -> void:
	# Delete me when the delete button is clicked
	self.queue_free()
	if FileAccess.file_exists(Global.zap_folder_loop + self.name + ".scn"):
		DirAccess.remove_absolute(Global.zap_folder_loop + self.name + ".scn")


func loopname_set(_loopname: String):
	# Set the loop name on the title text when this func is called
	loopnameref = $Loop_Container/loopname_containermargin/loopname
	loopnameref.text = _loopname
	_loopname_window = _loopname

func _on_edit_button_button_down() -> void:
	# If clicking edit button, then open the loop editor interface.
	$Loop_Container/LoopButton_containermargin/EditButton.disabled = true
	var lp = loopeditor_scene.instantiate()
	root.add_child(lp)
	lp.receive_loopname(_loopname_window)
	await get_tree().create_timer(0.5).timeout
	$Loop_Container/LoopButton_containermargin/EditButton.disabled = false
func _on_move_up_button_button_down() -> void:
	get_parent().move_child(self , self.get_index() - 1)


func _on_move_down_button_button_down() -> void:
	get_parent().move_child(self , self.get_index() + 1)
