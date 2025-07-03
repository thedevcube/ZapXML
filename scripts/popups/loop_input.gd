extends Panel
@onready var input = $"../Input"

var callback: Callable

func _ready():
	get_parent().open_tween()
	input.grab_focus()

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		$"../Confirm".button_down.emit()

func on_confirm() -> void:
	callback.call(input.text)
	get_parent().queue_free()

func on_cancel() -> void:
	get_parent().queue_free()
