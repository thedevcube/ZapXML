extends VBoxContainer
signal data_changed
signal end_ready
# A base script for all actions, so i dont have to create a script for each of em
var connected: Node
var end = preload("res://instances/Loop/loop_editor_nodes/other_actions/Choose order end.scn").instantiate()

@export_multiline var template = ""

@export var internal_name: String
@export var getter_order: Array[int] = [0 , 1]
## the node where all the actions are stored
@onready var actionlist = get_parent()
## The node that stores the value
@onready var value_node = get_node("ActionPanel/Value")
@onready var value_node_2 = get_node("ActionPanel/Value_2")
## State variable, just a workaround so when reloading will show the actual state of the button!
@export var state = ""
@export var state_2 = ""

## When converting, the converter gets THIS variable.
@export var convert_data = '<Press Key="Up" Model="_$Model" />'

@onready var id_text: Label = get_node("ActionPanel/id")
func _ready():
	load_values()

func generate_co():

	get_parent().add_child(end)
	end.start = self
	end.folder_name += "_" + folder_name
	end.connect("delete_requested" , _on_delete_action_button_down)
	connected = end

func load_values():
# auto select when reloading this action
	value_node.state_load(state)
	value_node_2.state_load(state_2)
	find_end()


#region basic
# Up moving action
func _on_move_action_up_button_down() -> void:
	actionlist.move_child(self , get_index() - 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse((self.get_child(0).get_child(2).position + Vector2(5,5)))

# Down moving action
func _on_move_action_down_button_down() -> void:
	actionlist.move_child(self , get_index() + 1)
	if connected.get_index() == get_index() - 1: 
		actionlist.move_child(connected , get_index() + 1)
		actionlist.move_child(self , connected.get_index() - 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse(self.get_child(0).get_child(3).position)

# Deleting action
func _on_delete_action_button_down() -> void:
	queue_free()
	connected.queue_free()
#endregion


func _process(_delta) -> void:
# constantly keep the convert_data up to date, we use gui input so we don't run it every frame
	state = value_node.get_value()
	state_2 = value_node_2.get_value()
	if has_formatting == true:
		convert_data = template % [value_node.get_value() , value_node_2.get_value()]
		data_changed.emit()

	if connected == null:
		find_end()
@export var has_formatting = true

func transmit_data(data , parser: XMLParser = null , textnode = null , loading = false):
	if not loading and data is Dictionary: 
		state = data.get(data.keys()[getter_order[0]])
		state_2 = data.get(data.keys()[getter_order[1]])
		generate_co()
		collapsed == true
		toggle_tree(false)
		data_received.emit()
	else: 
		state = data[0]
		state_2 = data[1]
		collapsed = data[2]
		find_end()
		toggle_tree(false)
		data_received.emit()
	load_values()

signal data_received

@export var folder_name: String
func get_as_dic(what):
	match what:
		"name":
			await data_changed
			return [value_node.get_value() , value_node_2.get_value() , collapsed , randf_range(0 , 100)]
		"data":
			await data_changed
			return [internal_name , folder_name]

@export var collapsed = false
var recorded_children: Array[Node]
func toggle_tree(toggle = true) -> void:
	if toggle: collapsed = not collapsed

	if not collapsed:
		var count = get_index()
		for child in recorded_children:
			get_parent().move_child(child , count + 1)
			count += 1
			child.show()
		recorded_children.clear()

	if collapsed:
		for child in get_parent().get_children():
			if child.get_index() > get_index() and child.get_index() < connected.get_index() + 1:
				recorded_children.append(child)
				child.hide()
			else: continue

func find_end():
	for child in get_parent().get_children():
		if child.internal_name == "Choose order end" and child.start == null:
			child.start = self
			break
