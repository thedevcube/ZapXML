extends Button

@onready var itemlist = $"../Panel/Initlist_scroll/Init_List"
@onready var tabs = $"../ItemList_tabs"
@onready var compiled_text = $"../ItemXML_compiledtext"
@onready var loop_area = $"../Loops_tab/MarginContainer/ScrollContainer/VBoxContainer"
@onready var streamplayer = $"../AudioStreamPlayer"
var regex = RegEx.new()

# CHECKS IF THE CONVERT BUTTON IS CICKED, THEN CALL CONVERT THE LIST
func _on_button_down() -> void:
	streamplayer.stream = preload("res://sounds/ui_window_options.wav"); streamplayer.play()
	tabs.current_tab = 2
	convert_list()


func convert_list():
	compiled_text.text = ''

#converting init
	if $"../buttonscont/init_toggle".button_pressed == true:
		compiled_text.text += '<Init>\n'
		#converting INIT
		# Setting up base init, if on
		if $"../buttonscont/initdef_toggle".button_pressed == true: compiled_text.text += '    <SetVariable Name="$Active" Value="1"/>\n'

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
		if $"../buttonscont/initdef_toggle".button_pressed == true: compiled_text.text += '    <SetVariable Name="Flag1" Value="0"/>\n'
		compiled_text.text += '</Init>\n\n'


#converting LOOP
	# if any loop exist
	if loop_area.get_child_count() > 0:
		# for every loop
		for loop in loop_area.get_child_count():
			var le := preload("res://instances/Loop/loop_editor.tscn").instantiate()
			# Store the current selected loop, 
			var loop_child: loop_template = loop_area.get_child(loop)
			loop_child.add_child(le)

			# Start an loop with this loop name
			append( ('<Loop>') if loop_child.loopnameref.text == "" else ('<Loop Name="%s">' % [loop_child.loopnameref.text]) )

## EVENTS
			append("<Events>" , 2)
			append(loop_child.data.get("event") , 4)
			append("</Events>" , 2)

			append("<Using>" , 2)

## USING
			if le.using_list.get_child_count() > 0:
				for child in le.using_list.get_children():
					await child.data_changed # wait for the values to load
					append(child.convert_data)

			append("</Using>" , 2)
			append("<Conditions>" , 2)

## CONDITIONS
			if le.condition_list.get_child_count() > 0:
				for child in le.condition_list.get_children():
					if "data_changed" in child: await child.data_changed # wait for the values to load
					append(child.convert_data , 4)

			append("</Conditions>" , 2)
			append("<Actions>" , 2)

## ACTIONS
			if le.action_list.get_child_count() > 0:
				for child in le.action_list.get_children():
					if "data_changed" in child: await child.data_changed # wait for the values to load
					append(child.data if not "convert_data" in child else child.convert_data , 4)

			append("</Actions>" , 2)
			append("</Loop>\n")

			le.queue_free()

## Append to the converted text
func append(atext: String , linespace: int = 0):
	var spaces = ' '.repeat(linespace)
	compiled_text.text += ('\n' + spaces + atext)

var alert_was_shown = false
