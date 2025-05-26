extends OptionButton

func _ready():
	# Clear items
	clear()
	var parser = XMLParser.new()
	parser.open("res://XML/ForcedAnimation.txt")
	while parser.read() != ERR_FILE_EOF:
		# GET TRICK NAME
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			# First we check for separators
			if "Separator" in parser.get_node_name():
				add_separator(parser.get_named_attribute_value("title"))
			# Then the animations
			else:
				add_item((parser.get_node_name()))
				for i in parser.get_attribute_count():
					set_item_metadata(item_count - 1 , parser.get_attribute_value(i))
					print(get_item_metadata(item_count - 1))
	remove_item(0)
	await get_parent().get_parent().ready
	get_parent().get_parent().reload_params()


func state_load(value):
		self.selected = value

func get_value():
	var me = self
	return me.get_item_text(me.get_selected_id() - 1)

func get_frame():
	var me = self
	return str(me.get_item_metadata(me.get_selected_id() - 1))

@onready var modelname_node = $"../Modelname"
func get_modelname():
	if modelname_node.text == '':
		return "_$Model"
	else:
		return modelname_node.text

@onready var reversed_node = $"../Reversed"
func get_reversed():
	if reversed_node.button_pressed == true:
		return "1"
	else:
		return "0"

func get_reversed_as_state():
	return reversed_node.button_pressed
