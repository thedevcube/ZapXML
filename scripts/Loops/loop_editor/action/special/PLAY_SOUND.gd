extends OptionButton

func _ready():
	var dir = DirAccess
	dir.open("res://sounds/")
	print(dir.get_files_at("res://sounds/"))
	# Clear items
	clear()
	var parser = XMLParser.new()
	parser.open("res://XML/Sounds.xml")
	while parser.read() != ERR_FILE_EOF:
		# GET SOUND NAME
		if parser.get_node_type() == XMLParser.NODE_ELEMENT and parser.get_node_name() == "song":
			for i in parser.get_attribute_count():
				add_item((parser.get_attribute_value(i)))


func state_load(value):
	print(value)
	if self.is_class("OptionButton"):
		self.selected = value
	if self.is_class("SpinBox"):
		self.value = value
	if self.is_class("LineEdit"):
		self.text = value

func get_value():
	if self.is_class("OptionButton"):
		var me = self
		return me.get_item_text(me.get_selected_id())
