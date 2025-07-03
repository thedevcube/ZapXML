extends Control

@export var textnode: Node

func get_text():
	return textnode.text

func button_click() -> void:
	var s: String = $CollapsibleContainer/XML.text
	if not s.is_empty():
		DisplayServer.dialog_show("Importing XML confirmation" , "Do you wish to clear the init and the loops before importing?" , PackedStringArray(["Yes" , "No"]) , confirmation_clearing)
		Global.load_xml(s , get_parent())
		$CollapsibleContainer.close_tween()
		$CollapsibleContainer/XML.text = ""
	else:
		Global.AOT_toggle.emit()
		OS.alert("XML field is empty." , "Error while importing XML")
		Global.AOT_toggle.emit()


@onready var initlist = get_node("../Panel/Initlist_scroll/Init_List")
@onready var looplist = get_node("../Loops_tab/MarginContainer/ScrollContainer/VBoxContainer")
func confirmation_clearing(id):
	match id:
		0:
			for child in Global.get_all_children(initlist):
				child.queue_free()
			for child in Global.get_all_children(looplist):
				child.queue_free()

func _ready():
	$CollapsibleContainer/XML.text_changed.connect(updatetext_frommain)
	$CollapsibleContainer2/XML_ex.text_changed.connect(updatetext_fromexp)

func updatetext_frommain():
	$CollapsibleContainer2/XML_ex.text = $CollapsibleContainer/XML.text

func updatetext_fromexp():
	$CollapsibleContainer/XML.text = $CollapsibleContainer2/XML_ex.text
