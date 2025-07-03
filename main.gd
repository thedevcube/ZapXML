extends Control


func _ready(): # Music, why not
	var stream = $Musicplayer
	var stream2 = $AudioStreamPlayer
	stream2.stream = preload("res://sounds/ui_window_profile.wav")
	stream.stream = preload("res://music/menu.mp3")
	stream2.play()

#region details
# Easter egg, Idea by Gordon, NOT IMPORTANT FOR THE APP'S USAGE
var text = ""
@onready var streamplayer = $AudioStreamPlayer

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_V):
		text = "v"
	if Input.is_key_pressed(KEY_E) and not "e" in text:
		text += "e"
	if Input.is_key_pressed(KEY_C) and not "c" in text:
		text += "c"
	if Input.is_key_pressed(KEY_T) and not "t" in text:
		text += "t"
	if Input.is_key_pressed(KEY_O) and not "o" in text:
		text += "o"
	if Input.is_key_pressed(KEY_R) and not "r" in text:
		text += "r"
	if text.begins_with("vector") and streamplayer.has_stream_playback() == false:
		streamplayer.stream = preload("res://sounds/m_jump1.wav")
		streamplayer.play()
		await get_tree().create_timer(0.1).timeout
		text = ""



func _on_musicplayer_finished() -> void:
	streamplayer.play()


func _on_music_togggle_button_down() -> void:
	if $buttonscont/music_toggle.button_pressed == false:
		$Musicplayer.play()
	else:
		$Musicplayer.stop()


func toggle_init_defaultvars() -> void:
	if $buttonscont/init_toggle.button_pressed == false:
		$buttonscont/initdef_toggle.hide()
	else:
		$buttonscont/initdef_toggle.show()


func soundtoggle() -> void:
	if $buttonscont/sfx_toggle.button_pressed == false:
		Global.volume = 1
		streamplayer.volume_linear = 1
	else:
		Global.volume = 0
		streamplayer.volume_linear = 0
#endregion

var loop_templatesn = preload("res://instances/Loop/loop_template.scn")
var loop_editor_scene = preload("res://instances/Loop/loop_editor.tscn")
func load_xml_def(text):

	var parser = XMLParser.new()
	parser.open_buffer(text.to_utf8_buffer())
	var current_xmltype = "Init"

	var array = ["Operator" , "Choose"]
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT and not parser.get_node_name() in array:
			if parser.get_attribute_count() == 0 or parser.has_attribute("Name") and parser.get_node_name() == "Loop":
				current_xmltype = parser.get_node_name()
			append(current_xmltype , parser , parser.get_node_name() , get_all_attributes_zxmlformat(parser) , parser.get_attribute_count() , true)

func get_all_attributes_zxmlformat(parser: XMLParser , iterate = true):
	var dic: Dictionary = {}

	if iterate == true: 
		for i in range(parser.get_attribute_count()):
			dic[parser.get_attribute_name(i)] = parser.get_attribute_value(i)
	else: dic[parser.get_attribute_name(0)] = parser.get_attribute_value(0)
	print(dic)
	return dic


var window_open = false
var current_loopeditor: loop_editor = null
func append(current_xmltype: String , parser: XMLParser , node_name: String = "", node_data: Dictionary = {}, input_count: int = 0, as_setxmltype = false):
	print("CURRENT XML TYPE IS: " , current_xmltype)

#region Init variables
# INIT
	if current_xmltype == "Init" and parser.get_attribute_count() > 0:
		var cust_var = preload("res://instances/Setvars/Custom.scn").instantiate()
		var itemlist: VBoxContainer = $Panel/Initlist_scroll/Init_List
		itemlist.add_child(cust_var)
		if parser.get_attribute_count() == 2: cust_var.load_value(parser.get_attribute_value(0) , parser.get_attribute_value(1))
#endregion

#region getting loop
# LOOP
	if "Loop" in current_xmltype and as_setxmltype:
		var looplist: VBoxContainer = get_node("Loops_tab/MarginContainer/ScrollContainer/VBoxContainer")
		var loop_temp: loop_template = loop_templatesn.instantiate()
		
		var clp: loop_editor = loop_editor_scene.instantiate()
		current_loopeditor = clp
		var loop_name = parser.get_attribute_value(0)
		print(loop_name)

		clp.current_loop_name = parser.get_named_attribute_value("Name")
		clp.receive_loopname("loop" if clp.current_loop_name.is_empty() else loop_name , false)
		loop_temp.loopname_set("loop" if clp.current_loop_name.is_empty() else loop_name)

		looplist.add_child(loop_temp)
		loop_temp.add_child(clp)
		clp.save_loop()
#endregion

#region actions
# Actions
	if current_xmltype == "Actions" and current_loopeditor != null:
		var loop_parser: XMLParser = XMLParser.new()
		loop_parser.open("res://XML/recognize_looptypes.xml")
		print("NODE NAME IS: ", node_name)

		while loop_parser.read() != ERR_FILE_EOF:

			if loop_parser.get_node_type() == XMLParser.NODE_ELEMENT:
				if loop_parser.get_node_name() == "action" and loop_parser.has_attribute("codename") and loop_parser.has_attribute("filename") and loop_parser.get_named_attribute_value("codename") == node_name and loop_parser.is_empty():
					if loop_parser.has_attribute("merge"):
						current_loopeditor.call_deferred("add_panel_element" , node_name , node_data , input_count , "action" , true , "")
						return
					else:
						current_loopeditor.call_deferred("add_panel_element" , node_name , node_data , input_count , "action" , false , loop_parser.get_named_attribute_value("filename"))
						return
#endregion

#region conditions
# conditions
	if current_xmltype == "Conditions" and current_loopeditor != null:
		var loop_parser: XMLParser = XMLParser.new()
		loop_parser.open("res://XML/recognize_looptypes.xml")
		print("NODE NAME IS: ", node_name)

		while loop_parser.read() != ERR_FILE_EOF:
			if loop_parser.get_node_type() == XMLParser.NODE_ELEMENT and loop_parser.is_empty() and not node_data.is_empty():
				current_loopeditor.call_deferred("add_panel_element" , node_name , node_data , input_count , "condition" , false , loop_parser.get_named_attribute_value("filename") , true)
				return
#endregion

#region using
# using
	if current_xmltype == "Using" and current_loopeditor != null:
		var loop_parser: XMLParser = XMLParser.new()
		loop_parser.open("res://XML/recognize_looptypes.xml")
		print("NODE NAME IS: ", node_name)

		while loop_parser.read() != ERR_FILE_EOF:

			if loop_parser.get_node_type() == XMLParser.NODE_ELEMENT and loop_parser.is_empty() and not node_data.is_empty():
						current_loopeditor.call_deferred("add_panel_element" , node_name , node_data , input_count , "using" , false , loop_parser.get_named_attribute_value("filename") )
						return
#endregion
