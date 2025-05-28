extends PanelContainer

@onready var loop_area = $MarginContainer/VBoxContainer

var loop_template = preload("res://instances/Loop/loop_template.scn")
var addloop_window = false




# OPEN THE LOOP TITLE MENU
func _on_add_loop_button_down() -> void:
	DisplayServer.dialog_input_text("Loop name" , "Insert loop name" , "" , receive_loopname)

# SET THE LOOP NAME ON THE WINDOW TITLE BAR BY CALLING ITS FUNCTION
func receive_loopname(loop_name: String):
	if loop_name.is_empty():
		loop_name = "loop"
	var looptemp_new = loop_template.instantiate()
	looptemp_new.name = loop_name
	if loop_area.get_child_count() != 0:
		for looparea_child in loop_area.get_child_count():
			var looparea_childnode = loop_area.get_child(looparea_child)
			if looparea_childnode.name == loop_name:
				loop_area.add_child(looptemp_new)
				looptemp_new.name = loop_name
				looptemp_new.loopname_set(looptemp_new.name)
			else:
				loop_area.add_child(looptemp_new)
				looptemp_new.name = loop_name
				looptemp_new.loopname_set(looptemp_new.name)
	else:
		loop_area.add_child(looptemp_new)
		looptemp_new.name = loop_name
		looptemp_new.loopname_set(looptemp_new.name)
