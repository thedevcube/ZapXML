extends VBoxContainer
# A base script for all actions, so i dont have to create a script for each of em

@export_multiline var template = ""

## the node where all the actions are stored
@onready var actionlist = get_parent()
## The node that stores the value
@onready var value_node = get_node("ActionPanel/Value")
## State variable, just a workaround so when reloading will show the actual state of the button!
@export var state = ""

## When converting, the converter gets THIS variable.
@export var convert_data = '<Press Key="Up" Model="_$Model" />'


func _ready():
# auto select when reloading this action
	if value_node != null : value_node.state_load(state)


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
	if value_node != null : state = value_node.get_value(true)
	if has_formatting == true:
		convert_data = template % [value_node.get_value()]
@export var has_formatting = true
