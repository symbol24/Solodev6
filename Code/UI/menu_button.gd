class_name RiDMenuButton extends Control


@export var text:String = ""
@export var destination:String = ""
@export var tween_time:float = 0.1
@export var tween_scale:Vector2 = Vector2(1.05, 1.05)
@export var normal:StyleBoxFlat
@export var hover:StyleBoxFlat

@onready var panel: Panel = %panel
@onready var label: Label = %label

var mouse_over:bool = false


func _input(event: InputEvent) -> void:
	if mouse_over and event.is_action_pressed("mouse_left"):
		_pressed()


func _ready() -> void:
	panel.mouse_entered.connect(_mouse_enter)
	panel.mouse_exited.connect(_mouse_exit)
	label.text = text


func _mouse_enter() -> void:
	mouse_over = true
	panel.add_theme_stylebox_override("panel", hover)
	var tween:Tween = create_tween()
	tween.tween_property(self, "scale", tween_scale, tween_time)


func _mouse_exit() -> void:
	mouse_over = false
	panel.add_theme_stylebox_override("panel", normal)
	var tween:Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), tween_time)


func _pressed() -> void:
	match destination:
		"play":
			Signals.LoadScene.emit("world", true)
		"settings":
			Signals.ToggleDisplay.emit("settings", "main_menu")
		"credits":
			Signals.ToggleDisplay.emit("credits", "main_menu")
		_:
			pass