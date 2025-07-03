extends Button
@onready var dialog: ConfirmationDialog = get_node("ConfirmationDialog")
@onready var init_list = get_node("../Loops_tab/MarginContainer/ScrollContainer/VBoxContainer")
@export var delete_node: Node

func pressed() -> void:
	dialog.popup_centered()


func confirmed() -> void:
	for child in delete_node.get_children():
		child.queue_free()


func canceled() -> void:
	dialog.hide()
