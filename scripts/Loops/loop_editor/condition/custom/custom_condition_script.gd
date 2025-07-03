extends VBoxContainer
signal data_changed

# A base script for all conditions, so i dont have to create a script for each of em

@export var get_as_item_id = false
@export var getter_order: Array[int] = [0 , 1]
@export var internal_name: String
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
@export var operator_state: int

## When converting, the converter gets THIS variable.
@export var convert_data = '<Equal Value1="?getModel[_$Model].AI" Value2="1" />'

func _ready():
	load_values()



func load_values() -> void:
	value_node.text = value_state
	ifthis_node.text = ifthis_state
	print("state is ", operator_state)
	operator.selected = operator_state

# Deleting
func _on_delete_action_button_down() -> void:
	queue_free()


@onready var operator = get_node("ConditionPanel/Operator")
func _process(_delta) -> void:
# constantly keep the convert_data up to date
	value_state = value_node.text
	ifthis_state = ifthis_node.text
	convert_data = '<%s %s="%s" %s="%s" />' % [operator.get_opr() , operator.get_opr_prefix() , ifthis_node.get_value() , ' ' + operator.get_opr_syntax() , value_node.get_value()]
	value_node.placeholder_text = '%s to this' % [operator.get_opr()]
	data_changed.emit()


func transmit_data(data , parser: XMLParser = null , textnode = null , loading = false , condition_name = "") -> void:
	if not loading and data is Dictionary: 
		print(data)
		ifthis_state = str(data[data.keys()[0]])
		value_state = str(data[data.keys()[1]])
		operator_state = operator.get_astext_selected(condition_name)
	else: 
		ifthis_state = data[0]
		value_state = data[1]
		operator_state = data[2]
	load_values()


func get_as_dic(what): # -> array
	match what:
		"name":
			return [ifthis_node.text , value_node.text , operator.get_selected() , randf_range(0 , 100)]
		"data":
			return [internal_name , "conditions"]
