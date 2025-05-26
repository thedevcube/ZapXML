extends VBoxContainer
# A base script for all conditions, so i dont have to create a script for each of em

@export var my_condition_value = ""
@export var my_check_prefix = ""
@export var my_check_suffix = ""

## the node where all the conditions are stored
@onready var conditionlist = get_parent()
## The node that stores the value
@onready var value_node = get_node("ConditionPanel/Value")
@onready var ifthis_node = get_node("ConditionPanel/ifthis")
## what is this condition? set in editor
@export var condition = ""
## State variable, just a workaround so when reloading will show the actual state of the button!
@export var ifthis_state = ""
@export var value_state = ""

## When converting, the converter gets THIS variable.
@export var convert_data = '<Equal Value1="?getModel[_$Model].AI" Value2="1" />'

func _ready():
	value_node.text = value_state
	ifthis_node.text = ifthis_state

# Deleting
func _on_delete_action_button_down() -> void:
	queue_free()


@onready var operator = get_node("ConditionPanel/Operator")
func _process(_delta):
# constantly keep the convert_data up to date
	value_state = value_node.text
	ifthis_state = ifthis_node.text
	convert_data = '<%s %s="%s" %s="%s" />' % [operator.get_opr() , operator.get_opr_prefix() , ifthis_state , ' ' + operator.get_opr_syntax() , value_state ]
	value_node.placeholder_text = '%s to this' % [operator.get_opr()]
