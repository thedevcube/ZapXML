extends Panel

@export var positione: Vector2 = Vector2(0,0)
@export_multiline var template = '<SetVariable Name="%s" Value="%s" />'
@export var data = ""

@onready var valuenode: LineEdit = get_node("value")
@onready var namenode: LineEdit = get_node("name")

var excluded_varnames = ["$Active" , "Flag1"]
func load_value(vname , vvalue):
	if vname in excluded_varnames: queue_free()
	namenode.text = vname
	valuenode.text = vvalue
	check_type_posimport(vname , vvalue)

func alter_data(vname , vvalue):
	data = template % [vname , vvalue]


func _on_name_text_changed(new_text: String) -> void:
	alter_data(new_text , valuenode.text)


func _on_value_text_changed(new_text: String) -> void:
	alter_data(namenode.text , new_text)


func _on_delbutton_button_down() -> void:
	queue_free()

func check_type_posimport(newname , data):
	match newname:

		"$AI":
			var node = preload("res://instances/Setvars/AI number.scn").instantiate()
			var currentindex = get_index()
			get_parent().add_child(node)
			get_parent().move_child(node , currentindex)
			node.get_child(1).value = int(data)
			queue_free()

		"$Node":
			var node = preload("res://instances/Setvars/Node type.scn").instantiate()
			var currentindex = get_index()
			var dropdownnode: OptionButton = node.get_child(1)
			for i in dropdownnode.item_count:
				if dropdownnode.get_item_text(i) == data:
					get_parent().add_child(node)
					get_parent().move_child(node , currentindex)
					dropdownnode.select(i)
					queue_free()
