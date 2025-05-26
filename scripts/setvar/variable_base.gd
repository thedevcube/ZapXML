extends Panel

@export var type = "$AI"
@export_multiline var template = '<SetVariable Name="%s" Value="%s" />'
@export var data = ""

@onready var valuenode = get_node("value")

func _ready():
	valuenode.update_data.connect(Callable(self , 'alter_data') )

func alter_data():
	data = template % [type , valuenode.get_var_value()]


func _on_delbutton_button_down() -> void:
	queue_free()
