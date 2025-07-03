extends Node
@export var linked_text: Node
@export var collapsible_container: CollapsibleContainer
@onready var my_loopeditor = get_node("../../../../../../../..")
var timer = Timer.new()

func timer_popped():
	if "text" in self and linked_text != null:
		if linked_text.text != self.text:
			if linked_text.text.length() > self.text.length():
				self.text = linked_text.text

func _ready() -> void:
	get_tree().current_scene.add_child(timer)
	var timermake = func():
		timer.autostart = true
		timer.one_shot = false
		timer.wait_time = 1
		timer.start(1)
		timer.timeout.connect(timer_popped)
	timermake.call()
	if linked_text != null:
		linked_text.text_changed.connect(_linked_text_has_changed)

	if collapsible_container != null:
		var me = self
		me.gui_input.connect(area_clicked)
		my_loopeditor.requested_collapse.connect(collapse_textarea)


func state_load(value) -> void:
		if self.is_class("OptionButton"):
			self.selected = value

		if self.is_class("SpinBox"):
			self.value = value

		if self.is_class("LineEdit"):
			self.text = parse_text(value)
			if is_instance_valid(linked_text): linked_text.text = parse_text(value)

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
		return get_text()

	if self.is_class("CheckButton"):
		var me = self
		if me.button_pressed == false:
			return 0
		else:
			return 1

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

func area_clicked(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse2"):
		my_loopeditor.requested_collapse.emit(collapsible_container)
		collapsible_container.open_toggle()

func collapse_textarea(exception: CollapsibleContainer) -> void : 
	if collapsible_container != null and collapsible_container != exception: collapsible_container.close()

func _linked_text_has_changed(_text = "") -> void:
	var me = self
	me.text = linked_text.text
