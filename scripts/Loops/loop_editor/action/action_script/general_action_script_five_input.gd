extends VBoxContainer
# A base script for all actions, so i dont have to create a script for each of em

@export_multiline var template = ""

## the node where all the actions are stored
@onready var actionlist = get_parent()
## The node that stores the value
@onready var value_node = get_node("ActionPanel/Value")
@onready var value_node_2 = get_node("ActionPanel/Value_2")
@onready var value_node_3 = get_node("ActionPanel/Value_3")
@onready var value_node_4 = get_node("ActionPanel/Value_4")
@onready var value_node_5 = get_node("ActionPanel/Value_5")
## what is this action? set in editor
@export var action = ""
## State variable, just a workaround so when reloading will show the actual state of the button!
@export var state = ""
@export var state_2 = ""
@export var state_3 = ""
@export var state_4 = ""
@export var state_5 = ""

## When converting, the converter gets THIS variable.
@export var convert_data = ''


func _ready():
# auto select when reloading this action
	value_node.state_load(state)
	value_node_2.state_load(state_2)
	value_node_3.state_load(state_3)
	value_node_4.state_load(state_4)
	value_node_5.state_load(state_5)

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
# constantly keep the convert_data up to date, we use gui input so we don't run it every frame
	state = value_node.get_value()
	state_2 = value_node_2.get_value()
	state_3 = value_node_3.get_value()
	state_4 = value_node_4.get_value(get_dropdown_as_item)
	state_5 = value_node_5.get_value(get_dropdown_as_item)
	if has_formatting == true:
		convert_data = template % [value_node.get_value() , value_node_2.get_value() , value_node_3.get_value() , value_node_4.get_value() , value_node_5.get_value()]
@export var has_formatting = true
@export var get_dropdown_as_item = false
