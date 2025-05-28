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
	remove_item(0)

func state_load(value):
	self.selected = int(value)

func get_value(return_item = false):
	var me = self
	if me is OptionButton:
		if return_item == false: return me.get_item_text(me.get_selected())
		else: return me.selected
	if me is LineEdit:
		if me.text != "":
			return me.get_item_text(me.get_selected())
		else: return "_$Model"

func get_frame():
	var me = self
	return me.get_item_metadata(me.get_selected())
