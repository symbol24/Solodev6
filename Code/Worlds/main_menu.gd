extends Node2D


func _ready() -> void:	
	Audio.play_audio(Audio.default.get_audio_file("main_menu"))
	Signals.ToggleDisplay.emit("main_menu", "")