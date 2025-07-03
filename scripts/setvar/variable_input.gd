extends Node
signal update_data

func get_var_value():
	var me = self
	match get_class():
		"SpinBox":
			return int(me.value)
		"OptionButton":
			return me.get_item_text(me.get_selected_id())
		"LineEdit":
			return me.text
		"CheckBox":
			if me.button_pressed: return 1
			else: return 0

func _input(event: InputEvent) -> void:
	update_data.emit()
