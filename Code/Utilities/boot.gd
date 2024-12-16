class_name Boot extends Node2D


@onready var godot: AnimatedSprite2D = %godot
@onready var logo: TextureRect = %logo
@onready var company_label: Label = %company_label
@onready var animator: AnimationPlayer = %animator

var current:String = ""
var can_press:bool = false


func _input(_event: InputEvent) -> void:
	if can_press and Input.is_anything_pressed():
		_play_next(current)


func _ready() -> void:
	Signals.LoadScene.emit("ui", FLAG_PROCESS_THREAD_MESSAGES)
	_play_next(current)
	await get_tree().create_timer(0.2).timeout
	can_press = true


func _play_next(anim:String) -> void:
	match anim:
		"godot":
			current = "logo"
		"logo":
			current = "done"
			Signals.LoadScene.emit("main_menu", false)
			queue_free()
		"":
			current = "godot"
		_:
			pass
	
	animator.play("RESET")
	await animator.animation_finished
	animator.play(current)
