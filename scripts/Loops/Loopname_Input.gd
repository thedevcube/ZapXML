extends Node2D

@onready var loopstab = self.get_parent().get_node("Loops_tab")
@onready var inputloopname = $InputLoopName
var regex = RegEx.new()

func _ready():
	# Focus on the text input once loaded in the scene.
	inputloopname.grab_focus()

func _on_confirm_button_button_down() -> void:
		regex.compile("^[a-zA-Z0-9_ ]+$")
		var result = regex.search(inputloopname.text)
		if result == null:
			OS.alert("Error: Not possible to create loop, possibly symbols on the name or empty name.")
		
		# When confirm button is clicked, inform the name, and disappear while freeing the slot
		else:
			loopstab.receive_loopname(inputloopname.text)
			loopstab.addloop_window = false
			self.queue_free()


func _on_cancel_button_button_down() -> void:
	# When cancel button is clicked, just disappear and free the slot
	self.queue_free()
	loopstab.addloop_window = false
