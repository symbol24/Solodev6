extends Area2D


var mouse_in:bool = false


func _input(event: InputEvent) -> void:
	if mouse_in and event.is_action_pressed("mouse_left"):
		print("Mouse in area and clicked")


func _mouse_enter() -> void:
	mouse_in = true


func _mouse_exit() -> void:
	mouse_in = false