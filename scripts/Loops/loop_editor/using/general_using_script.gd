extends VBoxContainer
signal data_changed
# A base script for all conditions, so i dont have to create a script for each of em
@export var template = ""

@export var internal_name: String
@export var get_as_item_id = false
## the node where all the conditions are stored
@onready var eventlist = get_parent()
## The node that stores the value
@onready var varname: Node  = get_node("UsingPanel/varname")
@onready var defvalue: Node  = get_node("UsingPanel/defvalue")
@onready var complexname: Node  = get_node("UsingPanel/complexname")
@onready var type_node: Node = get_node("UsingPanel/Type")



## State variable, just a workaround so when reloading will show the actual state of the button!
@export var name_state = ""
@export var complexname_state = ""
@export var default_value_State = ""
@export var type_state = ""

## When converting, the converter gets THIS variable.
@export var convert_data = '<Equal Value1="?getModel[_$Model].AI" Value2="1" />'

func load_values():
	if varname != null: varname.state_load(name_state)
	if defvalue != null: defvalue.state_load(default_value_State)
	if complexname != null: complexname.state_load(complexname_state)
	if type_node != null: type_node.get_item_by_text(type_state)

func _ready():
# auto select when reloading
	load_values()


# Deleting
func _on_delete_action_button_down() -> void:
	queue_free()

func _process(_delta):
# constantly keep the convert_data up to date
	name_state = varname.get_value()
	default_value_State = defvalue.get_value()
	complexname_state = complexname.get_value() if not complexname.get_value().is_empty() else ''
	type_state = type_node.get_value()
	convert_data = template % [name_state , default_value_State , '' if complexname_state.is_empty() else ' ComplexName="' + complexname_state + '"' , '' if type_state.is_empty() else (' Type="' + type_state + '"')]
	data_changed.emit()

func transmit_data(data , parser: XMLParser = null , textnode = null , loading = false) -> void:
	if not loading and data is Dictionary: 
		name_state = data.get(data.keys()[0])
		default_value_State = data.get(data.keys()[1])

		if data.has("ComplexName"):
			complexname_state = data.get("ComplexName")
		if data.has("Type"):
			type_state = data.get("Type")

	else: 
		name_state = data[0]
		default_value_State = data[1]
		complexname_state = data[2]
		type_state = data[3]

	load_values()

func get_as_dic(what): # -> array
	match what:
		"name":
			return [name_state , default_value_State , complexname_state , type_state , randf_range(0 , 100)]
		"data":
			return [internal_name , "using"]
