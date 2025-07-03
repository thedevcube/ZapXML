extends VBoxContainer
signal data_changed
# A base script for all actions, so i dont have to create a script for each of em

@export var internal_name: String
@export_multiline var template = ""
@export var getter_order: Array[int] = [0 , 1 , 2 , 3]
## the node where all the actions are stored
@onready var actionlist = get_parent()
## The node that stores the value
@onready var value_node = get_node("ActionPanel/Value")
@onready var value_node_2 = get_node("ActionPanel/Value_2")
@onready var value_node_3 = get_node("ActionPanel/Value_3")
@onready var value_node_4 = get_node("ActionPanel/Value_4")
## what is this action? set in editor
@export var action = ""
## State variable, just a workaround so when reloading will show the actual state of the button!
@export var state = ""
@export var state_2 = ""
@export var state_3 = ""
@export var state_4 = ""

## When converting, the converter gets THIS variable.
@export var convert_data = ''

func _ready():
	load_values()

func load_values():
# auto select when reloading this action
	value_node.state_load(state)
	value_node_2.state_load(state_2)
	value_node_3.state_load(state_3)
	value_node_4.state_load(state_4)

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
	state = value_node.get_value(get_dropdown_as_item)
	state_2 = value_node_2.get_value(get_dropdown_as_item)
	state_3 = value_node_3.get_value(get_dropdown_as_item)
	state_4 = value_node_4.get_value(get_dropdown_as_item)
	if has_formatting == true:
		convert_data = template % [value_node.get_value() , value_node_2.get_value() , value_node_3.get_value() , value_node_4.get_value()]
		data_changed.emit()
@export var has_formatting = true
@export var get_dropdown_as_item = false

func transmit_data(data , parser: XMLParser = null , textnode = null , loading = false):
	if not loading and data is Dictionary: 
		state = data.get(data.keys()[getter_order[0]])
		state_2 = data.get(data.keys()[getter_order[1]])
		state_3 = data.get(data.keys()[getter_order[2]])
		state_4 = data.get(data.keys()[getter_order[3]])
	else: 
		state = data[0]
		state_2 = data[1]
		state_3 = data[2]
		state_4 = data[3]
	load_values()

func get_as_dic(what):
	match what:
		"name":
			return [value_node.get_value() , value_node_2.get_value(), value_node_3.get_value() , value_node_4.get_value() , randf_range(0 , 100)]
		"data":
			return [internal_name , "actions"]
