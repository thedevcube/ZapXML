extends Button

@onready var itemlist = $"../Panel/Initlist_scroll/Init_List"
@onready var tabs = $"../ItemList_tabs"
@onready var compiled_text = $"../ItemXML_compiledtext"
@onready var loop_area = $"../Loops_tab/MarginContainer/VBoxContainer"
@onready var streamplayer = $"../AudioStreamPlayer"
var regex = RegEx.new()

# CHECKS IF THE CONVERT BUTTON IS CICKED, THEN CALL CONVERT THE LIST
func _on_button_down() -> void:
	streamplayer.stream = preload("res://sounds/ui_window_options.wav"); streamplayer.play()
	tabs.current_tab = 2
	convert_list()


func convert_list():
	#converting INIT
	# Setting up base var
	compiled_text.text = '<Init>\n    <SetVariable Name="$Active" Value="1"/>\n'

	# Checks if any variable is required,
	# this means that some action requested it.
	if not Global.required_init_vars.is_empty():
		# For every key add an variable based on it
		for required_init_key in Global.required_init_vars.keys():
			compiled_text.text += str("    " + Global.required_init_vars.get(required_init_key))
	# Repeat for x amount of items and add their metadata to text
	for i in range(itemlist.get_child_count()):
		compiled_text.text += ('    ' + itemlist.get_child(i).data + '\n')

	# Another basic vars
	compiled_text.text += '    <SetVariable Name="Flag1" Value="0"/>\n'
	compiled_text.text += '</Init>\n\n'


	#converting LOOP
	# if any loop exist
	if loop_area.get_child_count() > 0:
		# for every loop
		for loop in loop_area.get_child_count():
			# Store the current selected loop, 
			var loop_child = loop_area.get_child(loop)
			# Start an loop with this loop name
			compiled_text.text += '<Loop Name="' + loop_child.name + '">'
			# variable representing the current loop file
			var loop_instantiated = load(Global.zap_folder_loop + loop_child.name + ".scn")
			# If the file exists
			if loop_instantiated != null:
				# Now we instantiate it, and get its actionpanel child
				var loop_node = loop_instantiated.instantiate()
				var loop_action_node = loop_node.get_child(0).get_child(0).get_child(0)
				var loop_condition_node = loop_node.get_child(1).get_child(0).get_child(0)
				
				# Using
				if loop_action_node.using != "none":
					compiled_text.text += '\n  <Using>\n'
					compiled_text.text += '     ' + loop_action_node.using
					compiled_text.text += '\n  </Using>'
				
				# Events
				compiled_text.text += '\n <Events>\n'
				compiled_text.text += '   ' + loop_action_node.local_event
				compiled_text.text += '\n </Events>'
				
				
				# Conditions
				compiled_text.text += '\n <Conditions>'
				for i in range(loop_condition_node.get_child_count()):
					var c_node = loop_condition_node.get_child(i)
					compiled_text.text += str('\n       ' + c_node.convert_data)
				compiled_text.text += '\n </Conditions>'
				
				# Actions
				compiled_text.text += '\n  <Actions>'
				# Start choice order, if any
				if loop_action_node.choiceorder != "": compiled_text.text += str('\n  <Choice Order="' + loop_action_node.choiceorder + '" Set="1">')
				
				#...append the actions:
				for i in range(loop_action_node.get_child_count()):
					var action_node = loop_action_node.get_child(i)
					compiled_text.text += str('\n       ' + action_node.convert_data)
				
				# End choice order, if any
				if loop_action_node.choiceorder != "": compiled_text.text += '\n  </Choice>'
				
				# end the actions:
				compiled_text.text += '\n  </Actions>\n'
				
				# END THE LOOP PART
				compiled_text.text += '</Loop>\n\n'
			elif loop_instantiated == null:
						OS.alert("Error, one or more of your loops is not saved, therefore we can't proceed." , "Converting error")
						compiled_text.text = "ERROR! \nPlease make sure to save all of your loops before converting!\nSave them by clicking on edit > save, then close the window and try converting again."
						return

var alert_was_shown = false
