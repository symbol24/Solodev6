class_name Credits extends RiDControl


@onready var credits_back_btn: Button = %credits_back_btn


func _ready() -> void:
	super()
	credits_back_btn.pressed.connect(_back)


func _back() -> void:
	Signals.ToggleDisplay.emit(previous, id)