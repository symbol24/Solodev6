class_name DebugUi extends Control


@onready var fps: Label = %fps



func _process(_delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())