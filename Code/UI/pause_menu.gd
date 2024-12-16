class_name PauseMenu extends RiDControl


@export var pm_upgrade:PackedScene

@onready var trash_cargo: Label = %trash_cargo
@onready var debris_cargo: Label = %debris_cargo
@onready var scoop_height: Label = %scoop_height
@onready var scoop_length: Label = %scoop_length
@onready var speed: Label = %speed
@onready var batt_life: Label = %batt_life
@onready var recharge_rate: Label = %recharge_rate
@onready var depletion_rate: Label = %depletion_rate
@onready var damp: Label = %damp
@onready var upgrades_grid: GridContainer = %upgrades_grid
@onready var pause_mm_btn: Button = %pause_mm_btn
@onready var pause_close_btn: Button = %pause_close_btn
@onready var volume: HSlider = %volume

var all_upgrades:Array = []
var displayed_upgrades:Array[UpgradeData] = []
var vessel:Vessel


func _ready() -> void:
	super()
	all_upgrades = get_tree().get_nodes_in_group("upgrade_box")
	Signals.VesselReady.connect(_set_vessel)
	pause_close_btn.pressed.connect(_close)
	pause_mm_btn.pressed.connect(_main_menu)
	volume.value_changed.connect(_volume_changed)


func _set_vessel(_vessel:Vessel) -> void:
	vessel = _vessel


func _close() -> void:
		Signals.ToggleDisplay.emit("play_ui", "pause_menu", true)
		get_tree().paused = false


func _main_menu() -> void:
	Signals.LoadScene.emit("main_menu", true)


func _toggle_display(to_toggle:String, _previous:String, is_displayed:bool = true) -> void:
	if to_toggle == id:
		previous = _previous
		visible = is_displayed
		_update_stats()
		_update_upgrades()
		volume.value = Audio.get_current_volume_of_bus("Music")
	else:
		hide()


func _update_stats() -> void:
	if vessel:
		trash_cargo.text = str(vessel.collected_trash) + "/" + str(vessel.trash_capacity)
		debris_cargo.text = str(vessel.collected_debris) + "/" + str(vessel.debris_capacity)
		scoop_height.text = str(vessel.scoop_size.x)
		scoop_length.text = str(vessel.scoop_size.y)
		speed.text = str(vessel.speed)
		batt_life.text = str(vessel.max_battery)
		recharge_rate.text = str(vessel.max_recharge_rate) + "/s"
		depletion_rate.text = str(vessel.deplete_rate) + "/s"
		damp.text = str(vessel.current_damp)


func _update_upgrades() -> void:
	for each in all_upgrades:
		if each.data.purchased:
			if displayed_upgrades.find(each.data) == -1:
				displayed_upgrades.append(each.data)
	
	for each in displayed_upgrades:
		if not each.displayed_in_pause:
			var new = pm_upgrade.instantiate()
			upgrades_grid.add_child(new)
			new.set_values(each.texture, each.title, each.text)
			each.displayed_in_pause = true


func _volume_changed(value:float) -> void:
	Audio.BusVolumeUpdate.emit("Music", volume.value)