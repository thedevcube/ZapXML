extends Control

func _ready() -> void:
	if Global.warning_used == true:
		queue_free()
	$Window.show()
	print("SPAWNED")
	var tween = create_tween()
	tween.tween_property($Window/Label, "modulate:a", 1.0, 1.0)  # Fade in
	await get_tree().create_timer(5).timeout
	var tween2 = create_tween()
	tween2.tween_property($Window/Label, "modulate:a", 0.0, 1.0)  # Fade out
	await get_tree().create_timer(1).timeout
	queue_free()
	Global.warning_used = false

func show_message(message: String):
	$Window/Label.text = message
	Global.warning_used = true
