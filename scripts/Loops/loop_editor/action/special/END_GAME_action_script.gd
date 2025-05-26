extends VBoxContainer
# A base for all actions, so i dont have to create a script for each of em
# the node where all the actions are stored
@onready var actionlist = get_parent()
# basic nodes
@onready var holdframes = get_node("ActionPanel/Holdframes")
@onready var endtype = get_node("ActionPanel/EndType")
# State variable, just a workaround so when reloading will show the actual state of the button!
@export var holdframes_state = 120
@export var endtype_state = 2
# When converting, the converter gets THIS variable.
@export var convert_data = '<EndGame Result="Death" Model="_$Model" Frames="120" />'

func _ready():
	holdframes.value = holdframes_state
	endtype.selected = endtype_state

func _on_move_action_up_button_down() -> void:
	actionlist.move_child(self , get_index() - 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse((self.get_child(0).get_child(2).position + Vector2(5,5)))

func _on_move_action_down_button_down() -> void:
	actionlist.move_child(self , get_index() + 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse(self.get_child(0).get_child(3).position)


func _on_delete_action_button_down() -> void:
	queue_free()

func _process(_delta):
	convert_data = '<EndGame Result="' + endtype.get_item_text(endtype.get_selected_id()) +  '" Model="_$Model" Frames="' + str(roundi(holdframes.value)) + '" />'
