extends OptionButton

func _ready():
	var dir = DirAccess
	dir.open("res://sounds/")
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
	if self.is_class("OptionButton"):
		if value is int or value is float: 
			self.selected = int(value)
		else:
			for i in range(item_count):
				if get_item_text(i) == value:
					select(i)
					break

	if self.is_class("SpinBox"):
		self.value = value
	if self.is_class("LineEdit"):
		self.text = value

func get_value(as_item = false):
	var me = self
	if as_item == false:return get_item_text(get_selected_id())
	if as_item == true: return get_item_index(get_selected())


func _on_item_selected(index: int) -> void:
	var sound = load("res://sounds/" + get_item_text(index) + ".wav")
	var streamplayer = $"../AudioStreamPlayer"
	streamplayer.stream = sound
	streamplayer.play()
