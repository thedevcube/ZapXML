extends TabBar

@onready var itemlist = $"../Panel"
@onready var itemxml = $"../ItemXML_compiledtext"
@onready var loops_tab =  $"../Loops_tab"
@onready var add_loop_button = $"../Add_loop"
@onready var streamplayer = $"../AudioStreamPlayer"

func _on_tab_changed(tab: int) -> void:
	streamplayer.stream = preload("res://sounds/ui_click.wav"); streamplayer.play()
	if tab == 0: # show itemlist
		itemlist.show()
		itemxml.hide()
		loops_tab.hide()
		add_loop_button.hide()
	
	if tab == 1: # show loops tab
		itemlist.hide()
		itemxml.hide()
		loops_tab.show()
		add_loop_button.show()
	
	if tab == 2: # show xml
		itemlist.hide()
		itemxml.show()
		loops_tab.hide()
		add_loop_button.hide()
		get_tree().call_group("mb", "disable_me")
