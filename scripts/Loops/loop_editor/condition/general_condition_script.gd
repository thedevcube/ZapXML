extends VBoxContainer
# A base script for all conditions, so i dont have to create a script for each of em

@export var template = ""

## the node where all the conditions are stored
@onready var conditionlist = get_parent()
## The node that stores the value
@onready var value_node = get_node("ConditionPanel/Value")
## State variable, just a workaround so when reloading will show the actual state of the button!
@export_enum("integer" , "float" , "string") var state_type: int
@export var state_int = 0
@export var state_float = 0.0
@export var state_string = ""

## When converting, the converter gets THIS variable.
@export var convert_data = '<Equal Value1="?getModel[_$Model].AI" Value2="1" />'

func _ready():
# auto select when reloading
	if value_node != null and state_type == 0: value_node.state_load(state_int)
	if value_node != null and state_type == 1: value_node.state_load(state_float)
	if value_node != null and state_type == 2: value_node.state_load(state_string)

# Deleting
func _on_delete_action_button_down() -> void:
	queue_free()

@onready var operator = get_node("ConditionPanel/Operator")

func _process(_delta):
# constantly keep the convert_data up to date
	convert_data = template % [operator.get_opr() , operator.get_opr_prefix() , operator.get_opr_syntax() , str(value_node.get_value())]

	if state_type == 0: # Integer
		state_int = value_node.get_value()

	if state_type == 1: # Float
		state_float = value_node.get_value()

	if state_type == 2: # String
		state_string = value_node.get_value()
