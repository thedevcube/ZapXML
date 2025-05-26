extends VBoxContainer
# A base for all actions, so i dont have to create a script for each of em
# the node where all the actions are stored
@onready var actionlist = get_parent()
# State variable, just a workaround so when reloading will show the actual state of the button!
@export var varname_state = ""
@export var newvalue_state = ""
# When converting, the converter gets THIS variable.
@export var convert_data = '<EndGame Result="Death" Model="_$Model" Frames="120" />'

func reload_params():
	$ActionPanel/Value.text - newvalue_state
	$ActionPanel/varname.text = varname_state

func _on_move_action_up_button_down() -> void:
	actionlist.move_child(self , get_index() - 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse((self.get_child(0).get_child(2).position + Vector2(5,5)))

func _on_move_action_down_button_down() -> void:
	actionlist.move_child(self , get_index() + 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse(self.get_child(0).get_child(3).position)


func _on_delete_action_button_down() -> void:
	queue_free()

func _process(_delta):
	varname_state = $ActionPanel/varname.text
	newvalue_state = $ActionPanel/Value.text
	convert_data = str('<SetVariable Name="%s" Value="%s" />') % [varname_state , newvalue_state]
