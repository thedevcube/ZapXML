extends Window
var DATA_RECEIVER_NODE: Node

func _process(_delta):
	if Input.is_action_just_pressed("enterkey") and self.visible == true:
		# if enter is clicked, make our parent receive the input value
		if "text" in $TextEdit:
			DATA_RECEIVER_NODE.receive_value("" , $TextEdit.text)
		if "value" in $TextEdit:
			DATA_RECEIVER_NODE.receive_value("" , $TextEdit.value)
		
		self.queue_free()
	if Input.is_action_just_pressed("esc") and self.visible == true:
		# if esc is clicked, close this popup
		self.queue_free()

func centerit(): # center this popup on the screen
	self.popup_centered()
	self.exclusive = true
	$TextEdit.grab_focus()
