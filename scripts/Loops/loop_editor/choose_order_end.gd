extends VBoxContainer
signal delete_requested
@onready var id_text = get_node("ActionPanel/id")

@onready var actionlist = get_parent()
@export var internal_name: String
@export var data: String
@export var id: int
var start: Node
@export var convert_data: String
var folder_name: String = "other"

#region basics
func delete() -> void:
	delete_requested.emit()
	queue_free()
	start.queue_free()

func move_up() -> void:
	if get_index() > start.get_index() + 1:
		actionlist.move_child(self , get_index() - 1)
		await get_tree().create_timer(0.05).timeout
		warp_mouse((self.get_child(0).get_child(2).position + Vector2(5,5)))

# Down moving action
func move_down() -> void:
	actionlist.move_child(self , get_index() + 1)
	await get_tree().create_timer(0.05).timeout
	warp_mouse(self.get_child(0).get_child(3).position)
#endregion

func _ready():
	set_id()

func set_id(new_id = NAN):
	if new_id != NAN:
		id = new_id
		id_text.text = "ID: %d" % new_id
	else:
		id_text.text = "ID: %d" % id

func get_as_dic(what):
	match what:
		"name":
			return [data , id]
		"data":
			return [internal_name , folder_name]

func transmit_data(data , parser: XMLParser = null , textnode = null , loading = false):
	if not loading and data is Dictionary: 
		id = (data.get(data.keys()[1]))
		name = str(str(id) + "_end")

		for child in get_parent().get_children():
			if child.name == str(id):
				start = child
				break

		set_id(id)
	else: 
		id = data[1]
		name = str(str(id) + "_end")

		for child in get_parent().get_children():
			if child.name == str(id):
				start = child
				break

		set_id(id)
