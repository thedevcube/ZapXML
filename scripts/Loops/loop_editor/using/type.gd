extends OptionButton
class_name using_type

func _ready():
	clear()
	var parser = XMLParser.new()
	parser.open("res://XML/using_info.xml")
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			if node_name == "usingtype":
				add_item(parser.get_named_attribute_value("name"))

func get_value():
	return (get_item_text(get_selected())) if (get_item_text(get_selected())) != "None" else ""

func get_item_by_text(string: String):
	for i in item_count:
		if get_item_text(i) == string:
			select(i)
			break
