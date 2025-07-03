extends Window
class_name loop_editor
signal loop_saved
signal loop_loaded
signal closed
signal requested_collapse(exception)

var check_for_duplicates = false
@onready var my_template: loop_template = get_parent()
## The button list node that has all the events
@onready var events_list = $Control/Events_container/EventsNode
## The button list node that has all the actions
@onready var addnode = $Control/Add_container/AddNode
## The text node that shows the current event type
@onready var info_eventnode = $Control/panels/ActionPanel/Event
## The tabs button
@onready var tabs_button = $Control/Tabs
@onready var streamplayer = $AudioStreamPlayer

var current_loop_name = ""


func add_panel_element(element_name: String , element_data: Dictionary , input_count , type , merge = false , filename: String = "" , as_custom = false , parser: XMLParser = null , textnode = null):
	var elementd_1
	var element_merged
	if element_name != "" and as_custom == false:
		print("data: " , element_data , "name: " , element_name)
		elementd_1 = element_data.keys()[0]
		element_merged = "%s %s" % [element_name , elementd_1]
	var path: PackedScene

	match type:

		"action":
			if merge and as_custom == false:
				path = load("res://instances/Loop/loop_editor_nodes/actions/" + element_merged + ".scn")
			elif as_custom == false:
				path = load("res://instances/Loop/loop_editor_nodes/actions/" + filename + ".scn")
			if as_custom == true:
				path = preload("res://instances/Loop/loop_editor_nodes/actions/Custom.scn")
			var node = path.instantiate()
			action_list.add_child(node)
			if "transmit_data" in node: node.transmit_data(element_data , parser , textnode)
			return

		"condition":
			if merge and as_custom == false:
				path = load("res://instances/Loop/loop_editor_nodes/conditions/" + element_merged + ".scn")
			elif as_custom == false:
				path = load("res://instances/Loop/loop_editor_nodes/conditions/" + filename + ".scn")
			if as_custom == true:
				path = preload("res://instances/Loop/loop_editor_nodes/conditions/Custom.scn")
			var node = path.instantiate()
			condition_list.add_child(node)
			if "transmit_data" in node: node.transmit_data(element_data , parser , textnode , false , element_name)
			return

		"using":
			path = preload("res://instances/Loop/loop_editor_nodes/using/Variable.scn")
			var node = path.instantiate()
			using_list.add_child(node)
			if "transmit_data" in node: node.transmit_data(element_data , parser , textnode , false)
			return

func _notification(what: int) -> void:
# If the user wants to close the app, close it.
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("emited")
		closed.emit()
		queue_free()

# When resizing the window, resize the bg too
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		var bg = $Control/Sprite2D
		bg.scale.x = size.x * 0.001
		bg.scale.y = size.y * 0.001

func toggle_AOT(value = NAN):
	if value != NAN:
		match value:
			0: always_on_top = false
			1: always_on_top = true
	else:
		if always_on_top: always_on_top = false
		else: always_on_top = true

func _ready() -> void:
	for child in get_parent().get_children():
		if child.name.begins_with("Loopeditor") and child.get_instance_id() != get_instance_id() and check_for_duplicates:
			child.queue_free()
		else: name = "Loopeditor"
	$AudioStreamPlayer.volume_linear = Global.volume
	streamplayer.stream = preload("res://sounds/ui_window_shop.wav"); streamplayer.play()
	load_loop()

func _add_action(index) -> void:
	streamplayer.stream = preload("res://sounds/ui_window_shop.wav"); streamplayer.play()
	# Make a new variant var, load the action file that has the name of the
	# currently selected action
	var newnode
	newnode = load("res://instances/Loop/loop_editor_nodes/actions/" + addnode.get_item_text(index) + ".scn").instantiate()
	action_list.add_child(newnode)
	addnode.select(0)
	if "generate_co" in newnode: newnode.generate_co() # choice order

func receive_loopname(loopname: String , load_loop = true):
	# When receiving loop name, set the window title based on it.
	title = "Loop editor (" + loopname + ")"
	current_loop_name = loopname
	if load_loop: load_loop()

func _set_event(index: int) -> void:
	streamplayer.stream = preload("res://sounds/ui_window_shop.wav"); streamplayer.play()

	match events_list.get_item_text(index):
		"Help (information)": # Information
			always_on_top = false
			var helpfile = FileAccess.open("res://XML/Help.txt" , FileAccess.READ)
			OS.alert(helpfile.get_as_text() , "Events information")
			always_on_top = true
			events_list.select(0)

		"KeyPressed": # Keypressed, shows an dialog and minimizes this window

			always_on_top = false
			var keypress_func = func(index):
				match index:
					0:
						action_list.local_event = "<KeyPressed/>"
						action_list.event_text = "KeyPressed"
						info_eventnode.text = "KeyPressed"
					1:
						var node = preload("res://instances/Loop/loop_editor_nodes/using/Variable.scn").instantiate()
						using_list.add_child(node)
						var data = ["Key" , "Up" , "" , "Key"]
						node.transmit_data(data)
						action_list.local_event = "<KeyPressed/>"
						action_list.event_text = "KeyPressed"
						info_eventnode.text = "KeyPressed"
						name = "keypress_required_var"
					2:
						var node = preload("res://instances/Loop/loop_editor_nodes/using/Variable.scn").instantiate()
						using_list.add_child(node)
						var data = ["Key" , "Down" , "" , "Key"]
						node.transmit_data(data)
						action_list.local_event = "<KeyPressed/>"
						action_list.event_text = "KeyPressed"
						info_eventnode.text = "KeyPressed"
						name = "keypress_required_var"
					3:
						var node = preload("res://instances/Loop/loop_editor_nodes/using/Variable.scn").instantiate()
						using_list.add_child(node)
						var data = ["Key" , "Left" , "" , "Key"]
						node.transmit_data(data)
						action_list.local_event = "<KeyPressed/>"
						action_list.event_text = "KeyPressed"
						info_eventnode.text = "KeyPressed"
						name = "keypress_required_var"
					4:
						var node = preload("res://instances/Loop/loop_editor_nodes/using/Variable.scn").instantiate()
						using_list.add_child(node)
						var data = ["Key" , "Right" , "" , "Key"]
						node.transmit_data(data)
						action_list.local_event = "<KeyPressed/>"
						action_list.event_text = "KeyPressed"
						info_eventnode.text = "KeyPressed"
						name = "keypress_required_var"

			DisplayServer.dialog_show("Insert key" , "Insert the key to check" , PackedStringArray(["Any" , "Up" , "Down" , "Left" , "Right" ]) , keypress_func)
			always_on_top = true

		"ValueChange": # on value changed
			always_on_top = false
			var valuechange_func = func(vc_value):
				action_list.local_event = '<ValueChange Value="%s"/>' % [vc_value]
				action_list.event_text = "ValueChange"
				info_eventnode.text = "ValueChange"
				info_eventnode.tooltip_text = "Detects when '%s' changes." % [vc_value]

			DisplayServer.dialog_input_text("On value changed" , "Detects when a value is changed, specify what value to check" , "" , valuechange_func)
			always_on_top = true

		"Custom": # custom, shows an dialog and minimizes this window
			always_on_top = false
			var custom_event_func = func(ce_name):
				action_list.local_event = '<%s/>' % [ce_name]
				action_list.event_text = ce_name
				info_eventnode.text = ce_name
			DisplayServer.dialog_input_text("New custom event" , "Insert the custom event name" , "" , custom_event_func)
			always_on_top = true

## Checks if the keypressed required variable exists and deletes if keypress is not there.
	if events_list.get_item_text(index) != "KeyPressed":
		for child in using_list.get_children():
			if child.name.begins_with("keypress_required_var"):
				child.queue_free()

	var special = ["Help (information)" , "KeyPressed" , "ValueChange" , "Custom"]
	if events_list.get_item_text(index) not in special: # If the selected one isn't a special event, add it
		action_list.using = "none"
		info_eventnode.text = events_list.get_item_text(index)
		action_list.receive_event(events_list.get_item_text(index))



func _save_been_clicked() -> void:
	save_loop()

## The list of actions or conditions, basically our "father" in this hiearaquy... or whatever that was
@onready var action_list = get_node("Control/panels/ActionPanel/Margin/ScrollList")
@onready var condition_list = get_node("Control/panels/ConditionsPanel/Margin/ScrollList")
@onready var using_list = get_node("Control/panels/UsingPanel/Margin/ScrollList")
@onready var panel_list = get_node("Control/panels")

func get_all_children(node) -> Array: # By Real_TheoTheTorch
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes

func save_loop():
	my_template.data = {"event": action_list.get_event()}
	for node: Node in get_all_children(panel_list):
		if node is VBoxContainer and "get_as_dic" in node:
			my_template.data[await node.get_as_dic("name")] = [await node.get_as_dic("data")]
	loop_saved.emit()

func load_loop():
	for keys in my_template.data.keys():
		var key = my_template.data.get(keys)
		var key_name = my_template.data.find_key(key)

		if "event" in key_name:
			print(my_template.data)
			var event_baked = strip_xml_symbols(key , true)

			print(event_baked)
			events_list.select(10)

			for i in events_list.item_count:
				if event_baked in events_list.get_item_text(i):
					events_list.select(i)
					break

			var parser = XMLParser.new()
			var buffer = key.to_utf8_buffer()
			parser.open_buffer(buffer)
			while parser.read() != ERR_FILE_EOF:
				if parser.get_node_type() == XMLParser.NODE_ELEMENT:
					var node_name = parser.get_node_name()
					if parser.get_attribute_count() > 0:
## Recheck to select valuechange
						for i in events_list.item_count:
							if node_name in events_list.get_item_text(i):
								events_list.select(i)
								break

						event_baked = node_name
						info_eventnode.tooltip_text = "Detects when '%s' changes." % [parser.get_named_attribute_value("Value")]

			action_list.event_text = event_baked
			info_eventnode.text = event_baked
			action_list.local_event = key

			continue

		var bakedkey = key.get(0)
		var node = load("res://instances/Loop/loop_editor_nodes/" + bakedkey[1] + "/" + bakedkey[0] + ".scn").instantiate()

		match bakedkey[1]:

			"actions", "other_actions":
				action_list.add_child(node)
			"conditions", "other_conditions":
				condition_list.add_child(node)
			"using":
				using_list.add_child(node)

		
		if "transmit_data" in node: 
			node.transmit_data(keys , null , null , true)
			loop_loaded.emit()
		else: push_error(node , " Does not have an transmit data function.")
	loop_loaded.emit()

func _on_mouse_exited() -> void:
	# efficient, saves when the mouse leaves this window
	save_loop()

func custom_event(eventname):
	receive_event(eventname)


# receive value
func receive_event(value):
	pass
# CONDITIONS

@onready var usingpanel = $Control/panels/UsingPanel
@onready var actions_panel = $Control/panels/ActionPanel
@onready var conditions_panel = $Control/panels/ConditionsPanel

@onready var add_condition = $Control/Add_condition_container/AddCondition
@onready var add_using = $Control/Add_using_container/AddUsing

func tab_has_changed(tab: int) -> void:
	streamplayer.stream = preload("res://sounds/ui_click.wav"); streamplayer.play()
	match tab:
		0: # SHOW ACTIONS
			get_tree().call_group("Action nodes", "show")
			get_tree().call_group("Condition nodes", "hide")
			get_tree().call_group("Using nodes", "hide")


		1: # SHOW CONDITIONS
			get_tree().call_group("Action nodes", "hide")
			get_tree().call_group("Condition nodes", "show")
			get_tree().call_group("Using nodes", "hide")

		2: # SHOW USING
			get_tree().call_group("Action nodes", "hide")
			get_tree().call_group("Condition nodes", "hide")
			get_tree().call_group("Using nodes", "show")


func _add_condition(index: int) -> void:
	streamplayer.stream = preload("res://sounds/ui_window_shop.wav"); streamplayer.play()
	# Make a new variant var, load the action file that has the name of the
	# currently selected action
	var newnode
	newnode = load("res://instances/Loop/loop_editor_nodes/conditions/" + add_condition.get_item_text(index) + ".scn").instantiate()
	condition_list.add_child(newnode)
	if "generate_co" in newnode: newnode.generate_co() # choice order
	add_condition.select(0)

func _add_using(index: int) -> void:
	streamplayer.stream = preload("res://sounds/ui_window_shop.wav"); streamplayer.play()
	# Make a new variant var, load the action file that has the name of the
	# currently selected action
	var newnode
	newnode = load("res://instances/Loop/loop_editor_nodes/using/" + add_using.get_item_text(index) + ".scn").instantiate()
	using_list.add_child(newnode)
	add_using.select(0)

func reset_panels():
	actions_panel = panel_list.get_panel("actions_panel")
	action_list = panel_list.get_panel("action_list")
	condition_list = panel_list.get_panel("condition_list")
	using_list = panel_list.get_panel("using_list")
	conditions_panel = panel_list.get_panel("conditions_panel")
	info_eventnode = panel_list.get_panel("info_eventnode")

func strip_xml_symbols(text: String , capitalize = false):
	var newtext = text. replace("<" , "")
	newtext = newtext. replace(">" , "")
	newtext = newtext. replace("/" , "")
	if capitalize: newtext.capitalize()
	return newtext
