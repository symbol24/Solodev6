class_name LoseScreeen extends RiDControl


@onready var lose_screen_btn_exit: Button = %lose_screen_btn_exit


func _ready() -> void:
	super()
	lose_screen_btn_exit.pressed.connect(_main_menu)
	Signals.Lose.connect(_lose)


func _lose() -> void:
	get_tree().paused = true
	Signals.ToggleDisplay.emit(id, "", true)


func _main_menu() -> void:
	Signals.LoadScene.emit("main_menu", true)