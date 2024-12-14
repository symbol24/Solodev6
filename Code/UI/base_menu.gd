class_name BaseMenu extends RiDControl


@onready var base_menu_btn_close: Button = %base_menu_btn_close


func _ready() -> void:
	super()
	base_menu_btn_close.pressed.connect(_close_menu)


func _close_menu() -> void:
	Signals.ToggleDisplay.emit("play_ui", previous, true)
	Signals.VesselCanMove.emit()