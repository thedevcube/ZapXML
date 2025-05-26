extends Window
var DATA_RECEIVER_NODE: Node

func _process(_delta):
	if Input.is_action_just_pressed("esc") and self.visible == true:
		# when pressing esc, close this popup
		self.queue_free()

func centerit(): # Center this popup
	self.popup_centered()
	self.exclusive = true
	$Nodes.grab_focus()

## When an item is selected, confirm it.
func _on_nodes_item_selected(index: int) -> void:
	DATA_RECEIVER_NODE.receive_value("" , $Nodes.get_item_text(index))
	print($Nodes.get_item_text(index))
	self.queue_free()
