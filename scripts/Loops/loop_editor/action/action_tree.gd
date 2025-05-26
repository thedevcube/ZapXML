extends FlowContainer

@export var event_text = "Enter"
@export var local_event = "<Enter/>"
@export var choiceorder_state = 0
@export var choiceorder = ""
@export var using = "none"

func receive_event(event):
	local_event = "<" + event + "/>"
	event_text = event

func get_event():
	return local_event
