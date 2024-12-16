class_name WinScreen extends RiDControl


@onready var win_screen_btn_exit: Button = %win_screen_btn_exit
@onready var win_screen_btn_close: Button = %win_screen_btn_close


func _ready() -> void:
	super()
	Signals.Won.connect(_won)
	win_screen_btn_close.pressed.connect(_close)
	win_screen_btn_exit.pressed.connect(_main_menu)


func _won() -> void:
	get_tree().paused = true
	Signals.ToggleDisplay.emit("win_screen", "base_menu", true)


func _close() -> void:
	get_tree().paused = false
	Signals.ToggleDisplay.emit(previous, id, true)


func _main_menu() -> void:
	Signals.LoadScene.emit("main_menu", true)