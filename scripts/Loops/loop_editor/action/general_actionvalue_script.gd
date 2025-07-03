extends Node

## Shares same text
@export var linked_text: Node = null
@export var collapsible_container: CollapsibleContainer = null
@onready var my_loopeditor = get_node("../../../../../../../..")

@export_category("Text")
@export var uses_default_value = false
@export var default_value = ""
@export_category("Number")
@export var as_int = false

func _ready():

	if linked_text != null:
		linked_text.text_changed.connect(_linked_text_has_changed)

	if collapsible_container != null:
		var me = self
		me.gui_input.connect(area_clicked)
		my_loopeditor.requested_collapse.connect(collapse_textarea)

func area_clicked(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse2"):
		my_loopeditor.requested_collapse.emit(collapsible_container)
		collapsible_container.open_toggle()

func collapse_textarea(exception: CollapsibleContainer):
	if collapsible_container != null and collapsible_container != exception: collapsible_container.close()

func _linked_text_has_changed(_text = "") -> void:
	var me = self
	me.text = linked_text.text

func state_load(value) -> void:
	var me = self
	if self.is_class("OptionButton"):
		if value is int or value is float: 
			self.selected = int(value)
		else:
			for i in range(me.item_count):
				if me.get_item_text(i) == value:
					me.select(i)
					break

	if self.is_class("SpinBox"):
		if as_int == true: self.value = int(value)
		else: self.value = float(value)
	if self.is_class("LineEdit"):
		if value != "_$Model": self.text = parse_text(value)
	if self.is_class("CheckButton"):
		self.button_pressed = int(value)
	if self.is_class("ColorPicker"):
		self.color = value

func get_value(as_item = false):
	var me = self # Avoid error :(
	match self.get_class():

		"OptionButton":
			if as_item == false: return me.get_item_text(me.get_selected())
			else: return me.get_selected()

		"SpinBox":
			if as_int == true: return int(me.value) 
			if as_int == false: return str(snappedf(me.value , 0.01)).pad_decimals(2)

		"LineEdit":
			if not uses_default_value:
				return get_text()

			if uses_default_value:
				if me.text != "":
					return get_text()
				else:
					return default_value

		"CheckButton":
				return int(me.button_pressed)

		"ColorPicker":
			return me.get_pick_color()

const complex_names = {
	"?model": "?getModel",
	".node": ".getNode",
	".lpx": ".localPositionX",
	".lpy": ".localPositionY",
	".wpx": ".worldPositionX",
	".wpy": ".worldPositionY",
	".icf": ".isCameraFollow",
	".ic": ".isControlled",
	".c": ".condition"
}

func get_text() -> String:
	var eu = self
	var text: String = eu.text
	for complex in complex_names:
		if text.contains(complex):
			text = text.replace(complex , complex_names.get(complex))
	return text


func parse_text(text) -> String:
	for complex in complex_names.values():
		if text.contains(complex):
			text = text.replace(complex , complex_names.find_key(complex))
	return text
