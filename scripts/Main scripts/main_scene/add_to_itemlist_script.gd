extends OptionButton


#it used to be called itemlist, and i didn't want to change it.
@onready var itemlist = $"../Panel/Initlist_scroll/Init_List"

var selected_item = ""
@onready var streamplayer = $"../AudioStreamPlayer"

#region auto load
@export_dir var path = "res://instances/Loop/loop_editor_nodes/actions"

func _ready():
	var dir = DirAccess.open(path)
	for filecount in dir.get_files():
		if filecount.get_extension() == "scn":
			add_item(filecount.get_basename())
	select(0)
#endregion

var buttonclick: Array = ["res://sounds/ui_button_round_toggle.wav" , "res://sounds/ui_button_square_toggle.wav"]
func _on_item_selected(index: int) -> void:
	streamplayer.stream = load(buttonclick.pick_random()); streamplayer.play()
	select(0)
	var setvar = load("res://instances/Setvars/"+ get_item_text(index) + ".scn").instantiate()
	itemlist.add_child(setvar)


func _on_button_down() -> void:
	streamplayer.stream = preload("res://sounds/ui_button_big_toggle.wav"); streamplayer.play()
