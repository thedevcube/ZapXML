extends VBoxContainer



func _process(_delta):
	#delete selected items with the del key
	if Input.is_key_pressed(KEY_DELETE) and self.is_anything_selected():
		var selecteditems = self.get_selected_items()
		for index in selecteditems:
			self.remove_item(index)



func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	# On item clicked, enable the item options menu buttons, 
	#and if it's mouse2 pressed, show item options menu
	get_tree().call_group("mb", "enable_me")
	if mouse_button_index == 2:
		$"../ItemOptions".position = get_global_mouse_position()




func _on_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	# When an empty part of the itemlist is clicked,
	# deselect anything in the item list if there is, and disable
	# the item menu option buttons.
	if self.is_anything_selected():
		self.deselect_all()
		get_tree().call_group("mb", "disable_me")
