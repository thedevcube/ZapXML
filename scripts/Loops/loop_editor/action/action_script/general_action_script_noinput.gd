extends VBoxContainer
# A base script for all actions, so i dont have to create a script for each of em
## the node where all the actions are stored
@onready var actionlist = get_parent()
@export var internal_name: String
@export var data: String

# Up moving action
func _on_move_action_up_button_down() -> void:
	actionlist.move_child(self , get_index() - 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse((self.get_child(0).get_child(1).position + Vector2(5,5)))

# Down moving action
func _on_move_action_down_button_down() -> void:
	actionlist.move_child(self , get_index() + 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse(self.get_child(0).get_child(2).position)

# Deleting action
func _on_delete_action_button_down() -> void:
	queue_free()


func get_as_dic(what):
	match what:
		"name":
			return data
		"data":
			return [internal_name , "actions"]
