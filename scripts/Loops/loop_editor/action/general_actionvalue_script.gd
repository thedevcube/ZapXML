extends Node

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
