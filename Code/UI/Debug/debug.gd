class_name DebugUi extends Control


@onready var fps: Label = %fps
@onready var tnd_count: Label = %tnd_count


func _ready() -> void:
	Signals.LossCountUpdated.connect(_update_tnd)


func _process(_delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())



func _update_tnd(value:int) -> void:
	tnd_count.text = str(value)