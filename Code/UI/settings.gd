class_name Settings extends RiDControl


@onready var settings_back_btn: Button = %settings_back_btn
@onready var volume: HSlider = %volume


func _ready() -> void:
	super()
	settings_back_btn.pressed.connect(_back)
	volume.value_changed.connect(_volume_changed)


func _back() -> void:
	Signals.ToggleDisplay.emit(previous, id)


func _volume_changed(value:float) -> void:
	Audio.BusVolumeUpdate.emit("Music", volume.value)


func _toggle_display(to_toggle:String, _previous:String, is_displayed:bool = true) -> void:
	if to_toggle == id:
		previous = _previous
		visible = is_displayed
		volume.value = Audio.get_current_volume_of_bus("Music")
	else:
		hide()