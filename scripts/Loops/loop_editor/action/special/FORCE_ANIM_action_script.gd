extends VBoxContainer
# A base for all actions, so i dont have to create a script for each of em
# the node where all the actions are stored
@onready var actionlist = get_parent()
# basic nodes
@onready var anim_list = get_node("ActionPanel/Value")
@onready var modelname = get_node("ActionPanel/Modelname")
@onready var reversed = get_node("ActionPanel/Reversed")
# State variable, just a workaround so when reloading will show the actual state of the button!
@export var animname_state = 0
@export var modelname_state = ""
@export var reversed_state = false
@export var starting_frames = 0
# When converting, the converter gets THIS variable.
@export var convert_data = '<EndGame Result="Death" Model="_$Model" Frames="120" />'

func reload_params():
	anim_list.select(animname_state - 1)
	if modelname_state != "_$Model":
		modelname.text = modelname_state
	reversed.button_pressed = reversed_state

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
	animname_state = anim_list.get_selected_id()
	modelname_state = anim_list.get_modelname()
	reversed_state = anim_list.get_reversed_as_state()
	convert_data = str('<ForceAnimation Name="' + anim_list.get_value() +  '" Model="' + anim_list.get_modelname() +  '" Frame="' + anim_list.get_frame() + '" Reversed="' + anim_list.get_reversed() + '" />')
