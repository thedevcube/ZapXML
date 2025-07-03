extends VBoxContainer
signal data_changed
# A base script for all conditions, so i dont have to create a script for each of em
@export var template = ""

@export var internal_name: String
@export var get_as_item_id = false
## the node where all the conditions are stored
@onready var conditionlist = get_parent()
## The node that stores the value
@onready var value_node = get_node("ConditionPanel/Value")
## State variable, just a workaround so when reloading will show the actual state of the button!
@export var state = ""
@export var operator_state: int

## When converting, the converter gets THIS variable.
@export var convert_data = '<Equal Value1="?getModel[_$Model].AI" Value2="1" />'

func load_values():
	if value_node != null: value_node.state_load(state)
	if operator != null: operator.selected = operator_state

func _ready():
# auto select when reloading
	load_values()

# Deleting
func _on_delete_action_button_down() -> void:
	queue_free()

@onready var operator = get_node("ConditionPanel/Operator")

func _process(_delta):
# constantly keep the convert_data up to date
	state = value_node.get_value()
	convert_data = template % [operator.get_opr() , operator.get_opr_prefix() , operator.get_opr_syntax() , str(value_node.get_value())]
	data_changed.emit()

func transmit_data(data , parser: XMLParser = null , textnode = null , loading = false) -> void:
	if not loading and data is Dictionary: 
		state = data.get(data.keys()[0])
		operator_state = data.get(data.keys()[1])
	else: 
		state = data[0]
		operator_state = data[1]
	load_values()


func get_as_dic(what): # -> array
	match what:
		"name":
			return [value_node.text , operator.get_opr(get_as_item_id) , randf_range(0 , 100)]
		"data":
			return [internal_name , "conditions"]
