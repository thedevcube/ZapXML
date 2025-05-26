extends VBoxContainer
# A base script for all actions, so i dont have to create a script for each of em

@export var my_prefix = ""
@export var my_suffix = ""

## the node where all the actions are stored
@onready var actionlist = get_parent()
## The node that stores the value
@onready var value_node = get_node("ActionPanel/Value")
## what is this action? set in editor
@export var action = ""
## State variable, just a workaround so when reloading will show the actual state of the button!
@export_enum("integer" , "float" , "string" , "none") var state_type: int
@export var state_int = 0
@export var state_float = 0.0
@export var state_string = ""

## When converting, the converter gets THIS variable.
@export var convert_data = '<Press Key="Up" Model="_$Model" />'

func _ready():
# auto select when reloading this action
	if value_node != null and state_type == 0: value_node.state_load(state_int)
	if value_node != null and state_type == 1: value_node.state_load(state_float)
	if value_node != null and state_type == 2: value_node.state_load(state_string)


# Up moving action
func _on_move_action_up_button_down() -> void:
	actionlist.move_child(self , get_index() - 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse((self.get_child(0).get_child(1).position + Vector2(5,5)))

# Down moving action
func _on_move_action_down_button_down() -> void:
	actionlist.move_child(self , get_index() + 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse(self.get_child(0).get_child(2).position)

# Deleting action
func _on_delete_action_button_down() -> void:
	queue_free()


func _process(_delta):
	#constantly keep the convert_data up to date
	if state_type == 1: # Float
		state_float = value_node.value
		convert_data = my_prefix + str(snappedf(value_node.value , 0.01)) + my_suffix

	if state_type == 0: # Integer
		if "value" in value_node: # check if is number input
			state_int = value_node.value
			convert_data = my_prefix + str(roundi(value_node.value)) + my_suffix

	if state_type == 2: # String
		var specific = "cam_follow kill" # What actions to ignore from the update
		if not specific in action: 
			convert_data = my_prefix + value_node.text + my_suffix
# Below is setting the convert_data separately because of different reasons.
		if action == "cam_follow":
			if value_node.text != "":
				convert_data = '<Camera Follow="' + value_node.text + '" />'
				state_string = value_node.text
			else:
				convert_data = '<Camera Follow="_$Model" />'
		if action == "kill":
			if value_node.text != "":
				convert_data = my_prefix + value_node.text + my_suffix
				state_string = value_node.text
			else:
				convert_data = '<Kill Model="_$Model" />'
				state_string = '<Kill Model="_$Model" />'


#       Special cases


# FOR SIMULATE KEY ONLY (Change the convert_data to the list accordingly)
func _on_keys_item_selected(index: int) -> void:
	if action == "sound":
		var player = $ActionPanel/AudioStreamPlayer
		player.stream = load("res://sounds/%s.wav" % [value_node.get_item_text(index)])
		player.play()
	state_int = index
	convert_data = my_prefix + value_node.get_item_text(value_node.get_selected_id()) + my_suffix


# FOR WAIT ONLY (When mouse leaves the number field, unfocus it)
func WAIT_ONLY_on_value_mouse_exited() -> void: 
	if action == "wait": value_node.get_line_edit().release_focus()

# FOR CONTROL ONLY (Change convert data accordingly to the selected option)
func _control_on_value_item_selected(index: int) -> void:
	state_int = index
	convert_data = '<Control Switch="' + value_node.get_item_text(value_node.get_selected_id()) + '" Model="_$Model" />'
