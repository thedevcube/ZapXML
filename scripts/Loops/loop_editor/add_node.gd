extends OptionButton

func _ready():
	var dir = DirAccess.open("res://instances/Loop/loop_editor_nodes/")
	for filecount in dir.get_files():
		if filecount.get_extension() == "scn":
			add_item(filecount.get_basename())
	select(0)
