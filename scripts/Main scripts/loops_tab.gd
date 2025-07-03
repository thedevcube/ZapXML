extends PanelContainer

@onready var loop_area = $MarginContainer/ScrollContainer/VBoxContainer

var loop_template = preload("res://instances/Loop/loop_template.scn")
var addloop_window = false


# OPEN THE LOOP TITLE MENU
func _on_add_loop_button_down() -> void:
	var input = Global.display_loop(self , receive_loopname)

# SET THE LOOP NAME ON THE WINDOW TITLE BAR BY CALLING ITS FUNCTION
func receive_loopname(loop_name: String):
	var looptemp_new = loop_template.instantiate()
	loop_area.add_child(looptemp_new)
	looptemp_new.name = ("" if loop_name.is_empty() else loop_name)
	looptemp_new.loopname_set("" if loop_name.is_empty() else loop_name)
