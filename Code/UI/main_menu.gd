class_name MainMenu extends RiDControl


@onready var animator: AnimationPlayer = %animator


func _toggle_display(to_toggle:String, _previous:String, is_displayed:bool = true) -> void:
	if to_toggle == id:
		previous = _previous
		visible = is_displayed
		animator.play("entry")
	else:
		hide()