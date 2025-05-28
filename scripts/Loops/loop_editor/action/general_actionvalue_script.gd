extends Node

@export_category("Text")
@export var uses_default_value = false
@export var default_value = ""
@export_category("Number")
@export var as_int = false

func state_load(value):
	if self.is_class("OptionButton"):
		self.selected = int(value)
	if self.is_class("SpinBox"):
		if as_int == false: self.value = float(value)
		else: self.value = int(value)
	if self.is_class("LineEdit"):
		if value != "_$Model": self.text = String(value)
	if self.is_class("CheckButton"):
		self.button_pressed = int(value)
	if self.is_class("ColorPicker"):
		self.color = value

func get_value(as_item = false):
	var me = self # Avoid error
	match self.get_class():

		"OptionButton":
			if as_item == false: return me.get_item_text(me.get_selected())
			else: return me.get_selected()

		"SpinBox":
			if as_int == false: return me.value
			else: return int(me.value)

		"LineEdit":
			if uses_default_value == false:
				return me.text
			if uses_default_value == true:
				if me.text != "":
					return me.text
				else:
					return default_value

		"CheckButton":
				return int(me.button_pressed)

		"ColorPicker":
			return me.get_pick_color()
