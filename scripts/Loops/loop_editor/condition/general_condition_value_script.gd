extends Node

func _ready():
	Global.saving_loop.connect(temp_show)
	Global.saving_loop_finished.connect(temp_hide)

func temp_show():
	var me = self
	me.show()

func temp_hide():
	var me = self
	me.hide()

func state_load(value):
	if self.is_class("OptionButton"):
		self.selected = value

	if self.is_class("SpinBox"):
		self.value = value

	if self.is_class("LineEdit"):
		self.text = value

	if self.is_class("CheckButton"):
		if value == 1:
			self.button_pressed = true
		if value == 2:
			self.button_pressed = false

func get_value():

	if self.is_class("OptionButton"):
		var me = self
		return me.get_item_text(me.get_selected_id())

	if self.is_class("SpinBox"):
		var me = self
		return me.value

	if self.is_class("LineEdit"):
		var me = self
		return str(me.text)

	if self.is_class("CheckButton"):
		var me = self
		if me.button_pressed == false:
			return 0
		if me.button_pressed == true:
			return 1
