extends Sprite2D

func _enter_tree() -> void:
	show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0,0,0,0), 0.5)
	tween.tween_callback(self.queue_free)
