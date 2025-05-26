extends Node
signal update_data

func get_var_value():
	var me = self
	match get_class():
		"SpinBox":
			return int(me.value)
		"OptionButton":
			return me.get_item_text(me.get_selected_id())

# FOR SPINBOX
func _on_value_changed(value: float) -> void:
	update_data.emit()

# FOR OPTIONBUTTON
func _on_item_selected(index: int) -> void:
	update_data.emit()
