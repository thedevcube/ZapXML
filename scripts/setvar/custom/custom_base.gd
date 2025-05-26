extends Panel

@export var positione: Vector2 = Vector2(0,0)
@export_multiline var template = '<SetVariable Name="%s" Value="%s" />'
@export var data = ""

@onready var valuenode = get_node("value")
@onready var namenode = get_node("name")

func alter_data(vname , vvalue):
	data = template % [vname , vvalue]


func _on_name_text_changed(new_text: String) -> void:
	alter_data(new_text , valuenode.text)


func _on_value_text_changed(new_text: String) -> void:
	alter_data(namenode.text , new_text)


func _on_delbutton_button_down() -> void:
	queue_free()
