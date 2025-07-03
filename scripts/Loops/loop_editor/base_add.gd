extends OptionButton

@export_dir var path = "res://instances/Loop/loop_editor_nodes/actions"

func _ready():
	var dir = DirAccess.open(path)
	for filecount in dir.get_files():
		if filecount.get_extension() == "scn":
			add_item(filecount.get_basename())
	select(0)
