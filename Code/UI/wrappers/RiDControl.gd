class_name RiDControl extends Control

@export var id:String 

var previous:String = ""


func _ready() -> void:
	Signals.ToggleDisplay.connect(_toggle_display)


func _toggle_display(to_toggle:String, _previous:String, is_displayed:bool = true) -> void:
	if to_toggle == id:
		previous = _previous
		visible = is_displayed
	else:
		hide()