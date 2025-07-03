extends Button
@export var action_list: Node
var co = preload("res://instances/Loop/loop_editor_nodes/other/Choose order.scn").instantiate()

func _ready() -> void:
	if not is_instance_valid(action_list): action_list = get_node("Control/panels/ActionPanel/Margin/ScrollList")

func clicked() -> void:
	action_list.add_child(co)
	co.generate_co()
