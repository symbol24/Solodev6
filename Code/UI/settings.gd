class_name Settings extends RiDControl


@onready var settings_back_btn: Button = %settings_back_btn
@onready var volume: HSlider = %volume

var current:float = 0.0

func _ready() -> void:
	super()
	settings_back_btn.pressed.connect(_back)
	volume.value_changed.connect(_volume_changed)
	current = Audio.default.music_volume


func _back() -> void:
	Signals.ToggleDisplay.emit(previous, id)


func _volume_changed(value:float) -> void:
	current = volume.value
	Audio.BusVolumeUpdate.emit("Music", current)


func _toggle_display(to_toggle:String, _previous:String, is_displayed:bool = true) -> void:
	if to_toggle == id:
		previous = _previous
		visible = is_displayed
		volume.value = current
	else:
		hide()