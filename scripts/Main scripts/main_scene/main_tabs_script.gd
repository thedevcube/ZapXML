extends TabBar

@onready var streamplayer = $"../AudioStreamPlayer"

func _on_tab_changed(tab: int) -> void:
	streamplayer.stream = preload("res://sounds/ui_click.wav"); streamplayer.play()
	if tab == 0: # show itemlist
		get_tree().call_group("Init", "show")
		get_tree().call_group("Loops", "hide")
		get_tree().call_group("Xml", "hide")

	if tab == 1: # show loops tab
		get_tree().call_group("Init", "hide")
		get_tree().call_group("Loops", "show")
		get_tree().call_group("Xml", "hide")

	if tab == 2: # show xml
		get_tree().call_group("Init", "hide")
		get_tree().call_group("Loops", "hide")
		get_tree().call_group("Xml", "show")
