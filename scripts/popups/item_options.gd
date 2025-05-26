extends Control
var node: Node

func receive_var(_tnode: Node):
	node = _tnode

func _on_delete_button_down() -> void:
	node.queue_free()
	position.y = -172.0
