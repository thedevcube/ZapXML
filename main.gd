extends Control


func _ready(): # Music, why not
	var stream = $Musicplayer
	stream.stream = preload("res://music/menu.mp3")
	stream.play()

# Easter egg, Idea by Gordon, NOT IMPORTANT FOR THE APP'S USAGE
var text = ""
@onready var streamplayer = $AudioStreamPlayer

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_V):
		text = ""
		text += "v"
	if Input.is_key_pressed(KEY_E) and not "e" in text:
		text += "e"
	if Input.is_key_pressed(KEY_C) and not "c" in text:
		text += "c"
	if Input.is_key_pressed(KEY_T) and not "t" in text:
		text += "t"
	if Input.is_key_pressed(KEY_O) and not "o" in text:
		text += "o"
	if Input.is_key_pressed(KEY_R) and not "r" in text:
		text += "r"
	if text.begins_with("vector") and streamplayer.has_stream_playback() == false:
		streamplayer.stream = preload("res://sounds/m_jump1.wav")
		streamplayer.play()
		await get_tree().create_timer(0.1).timeout
		text = ""


func _on_musicplayer_finished() -> void:
	streamplayer.play()


func _on_music_togggle_button_down() -> void:
	if $music_togggle.button_pressed == false:
		$Musicplayer.play()
	if $music_togggle.button_pressed == true:
		$Musicplayer.stop()
