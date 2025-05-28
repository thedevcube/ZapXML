extends Window

## The button list node that has all the events
@onready var events_list = $Control/Events_container/EventsNode
## The button list node that has all the actions
@onready var addnode = $Control/Add_container/AddNode
## The text node that shows the current event type
@onready var info_eventnode = $Control/panels/ActionPanel/Event
## The button list node that has all the choice orders
@onready var choiceorder = $Control/choiceorder
## The tabs button
@onready var tabs_button = $Control/Tabs
@onready var streamplayer = $AudioStreamPlayer

var current_loop_name = ""



func _notification(what: int) -> void:
# If the user wants to close the app, close it.
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		queue_free()

# When resizing the window, resize the bg too
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		var bg = $Control/Sprite2D
		bg.scale.x = size.x * 0.001
		bg.scale.y = size.y * 0.001




func _ready() -> void:
	for i in get_parent().get_child_count():
		var node = get_parent().get_child(i)
		if node.name == "loopeditor":
			always_on_top = false
			OS.alert("You already have an loop editor open for this loop!" , "Loop editor warning")
			queue_free()
		elif node.name != "loopeditor": streamplayer.stream = preload("res://sounds/ui_window_shop.wav"); streamplayer.play()
	name = "loopeditor"




func _on_mouse_entered() -> void:
	# When the mouse enters this node's field, grab focus
	grab_focus()

func _on_add_node_item_selected(index) -> void:
	streamplayer.stream = preload("res://sounds/ui_window_shop.wav"); streamplayer.play()
	# Make a new variant var, load the action file that has the name of the
	# currently selected action
	var array = ["Simulate key" , "Camera follow" ,  "Force animation" , "Kill model"]
	if array.has(addnode.get_item_text(index)):
		Global.show_warning("Warning: Actions that are executed on models only work properly when being absolutely specific with the model name instead of using '_$Model' (Leaving a model field blank.)")
	var newnode
	newnode = load("res://instances/Loop/loop_editor_nodes/" + addnode.get_item_text(index) + ".scn").instantiate()
	action_list.add_child(newnode)
	addnode.select(0)

func receive_loopname(loopname: String):
	# When receiving loop name, set the window title based on it.
	title = "Loop editor (" + loopname + ")"
	current_loop_name = loopname
	load_loop()

func _on_events_node_item_selected(index: int) -> void:
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
			DisplayServer.dialog_show("Insert key" , "Insert the key to check" , PackedStringArray(["Any" , "Up" , "Down" , "Left" , "Right" ]) , keypress_insert)
			always_on_top = true

		"ValueChange": # on value changed
			always_on_top = false
			DisplayServer.dialog_input_text("On value changed" , "Detects when a value is changed, specify what value to check" , "" , custom_event)
			always_on_top = true

		"Custom": # custom, shows an dialog and minimizes this window
			always_on_top = false
			DisplayServer.dialog_input_text("New custom event" , "Insert the custom event name" , "" , custom_event)
			always_on_top = true

	var special = ["Help (information)" , "KeyPressed" , "ValueChange" , "Custom"]
	if events_list.get_item_text(index) not in special: # If the selected one isn't a special event, add it
		action_list.using = "none"
		info_eventnode.text = events_list.get_item_text(index)
		action_list.receive_event(events_list.get_item_text(index))



func _on_save_button_button_down() -> void:
	save_loop()

## The list of actions or conditions, basically our "father" in this hiearaquy... or whatever that was
@onready var action_list = get_node("Control/panels/ActionPanel/Margin/ScrollList")
@onready var condition_list = get_node("Control/panels/ConditionsPanel/Margin/ScrollList")
@onready var panel_list = get_node("Control/panels")

func save_loop():
	# Check if zapxml's temporary folder exists, if it doesn't, make a new one
	if not DirAccess.dir_exists_absolute(Global.zap_folder_loop):
		push_error("The folder doesn't exist, creating one.")
		DirAccess.make_dir_recursive_absolute(Global.zap_folder_loop)
	else: # if it does, make all nodes present inside this loop have an owner so they get saved too.

# Save all panels
		for i in panel_list.get_child_count(): # first we get panels
			var child = panel_list.get_child(i)
			child.owner = panel_list

			for basic in child.get_child_count(): # then basic text and margin
				var basic_n = child.get_child(basic)
				basic_n.owner = panel_list

				for scrolllist in basic_n.get_child_count(): # scrolllist
					var scrolllist_ = basic_n.get_child(scrolllist)
					scrolllist_.owner = panel_list

					for nodes in scrolllist_.get_child_count(): # nodes
						var nodes_ = scrolllist_.get_child(nodes)
						nodes_.owner = panel_list


		# make a new packedscene where we'll store this whole thing, then pack it and save on the temporary folder.
		var packedscene = PackedScene.new()
		packedscene.pack(panel_list)
		ResourceSaver.save(packedscene , Global.zap_folder_loop + current_loop_name + ".scn")

func load_loop():
	# Checks if an scn file with the current loop name exists in the temporary folder
	if FileAccess.file_exists(Global.zap_folder_loop + current_loop_name + ".scn"):
		panel_list.queue_free() # delete the current loop, then reference the file that has the saved loop
		var new_panel_tree = load(Global.zap_folder_loop + current_loop_name + ".scn").instantiate()
		panel_list = new_panel_tree # save it in a variable, no idea why but it works this way
		reset_panels()
		get_child(0).add_child(panel_list) # then add the action tree
		info_eventnode.text = action_list.event_text # and load the texts with the actual values saved by the loop
		choiceorder.select(action_list.choiceorder_state)
		_ON_TAB_CHANGED(0)

func _on_mouse_exited() -> void:
	# efficient, saves when the mouse leaves this window
	save_loop()


#func _on_choiceorder_item_selected(index: int) -> void:
	#action_list.choiceorder_state = index
	#if index > 1:
		#action_list.choiceorder = choiceorder.get_item_text(index)
	#else:
		#action_list.choiceorder = ""

func custom_event(eventname):
	receive_value(eventname)

func keypress_insert(key):
	match key:
		0:
			receive_value("Any")
		1:
			receive_value("Up")
		2:
			receive_value("Down")
		3:
			receive_value("Left")
		4:
			receive_value("Right")

# receive value
func receive_value(value , _empty = null):
		if events_list.get_item_text(events_list.get_selected_id()) == "KeyPressed": # For keypress
			if value == "Any":
				mode = MODE_WINDOWED
				action_list.event_text = "KeyPressed"
				info_eventnode.text = "KeyPressed"
				action_list.local_event = "<KeyPressed />"
				action_list.using = "none"

			else:
				action_list.using = ""
				mode = MODE_WINDOWED
				action_list.event_text = str("OnKey: " + value)
				info_eventnode.text = action_list.event_text
				action_list.local_event = "<KeyPressed />"
				action_list.using += '<Variable Name="Key" DefaultValue="' + value + '" Type="Key" />'

		if events_list.get_item_text(events_list.get_selected_id()) == "ValueChange": # For valuechange
				mode = MODE_WINDOWED
				action_list.event_text = "ValueChange"
				info_eventnode.text = "Value Change"
				info_eventnode.tooltip_text = "Detects when '%s' changes." % [value]
				action_list.local_event = '<ValueChange Value="%s"/>' % [value]
				action_list.using = "none"

		if events_list.get_selected_id() == 9: # For custom
			mode = MODE_WINDOWED
			action_list.event_text = str(value)
			info_eventnode.text = action_list.event_text
			action_list.local_event = value
			action_list.using = 'none'


func _on_choiceorder_item_selected(index: int) -> void:
	if index > 0:
		action_list.choiceorder = choiceorder.get_item_text(index)
		action_list.choiceorder_state = index
	else:
		action_list.choiceorder = ''
		action_list.choiceorder_state = 0



# CONDITIONS


@onready var actions_panel = $Control/panels/ActionPanel
@onready var add_condition = $Control/Add_condition_container/AddCondition
@onready var conditions_panel = $Control/panels/ConditionsPanel

func _ON_TAB_CHANGED(tab: int) -> void:
	streamplayer.stream = preload("res://sounds/ui_click.wav"); streamplayer.play()
	match tab:
		0: # SHOW ACTIONS
			actions_panel.show()
			addnode.show()
			choiceorder.show()

			conditions_panel.hide()
			add_condition.get_parent().hide()


		1: # SHOW CONDITIONS
			add_condition.get_parent().show()
			conditions_panel.show()

			actions_panel.hide()
			addnode.hide()
			choiceorder.hide()

func _on_add_condition_item_selected(index: int) -> void:
	streamplayer.stream = preload("res://sounds/ui_window_shop.wav"); streamplayer.play()
	# Make a new variant var, load the action file that has the name of the
	# currently selected action
	var newnode
	newnode = load("res://instances/Loop/loop_editor_nodes/conditions/" + add_condition.get_item_text(index) + ".scn").instantiate()
	condition_list.add_child(newnode)
	add_condition.select(0)


func reset_panels():
	actions_panel = panel_list.get_panel("actions_panel")
	action_list = panel_list.get_panel("action_list")
	condition_list = panel_list.get_panel("condition_list")
	conditions_panel = panel_list.get_panel("conditions_panel")
	info_eventnode = panel_list.get_panel("info_eventnode")
