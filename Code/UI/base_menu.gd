class_name BaseMenu extends RiDControl


@export var battery_tree:UpgradeTree
@export var engine_tree:UpgradeTree
@export var cargo_tree:UpgradeTree
@export var hull_tree:UpgradeTree
@export var scoop_tree:UpgradeTree

@onready var base_menu_btn_close: Button = %base_menu_btn_close
@onready var engine_text: Label = %engine_text
@onready var batt_text: Label = %batt_text
@onready var cargo_text: Label = %cargo_text
@onready var hull_text: Label = %hull_text
@onready var scoop_text: Label = %scoop_text

var all_upgrades:Array = []


func _ready() -> void:
	super()
	Signals.UpdateUpgradeBoxes.connect(_update_upgrades)
	base_menu_btn_close.pressed.connect(_close_menu)
	all_upgrades = get_tree().get_nodes_in_group("upgrade_box")
	engine_text.text = engine_tree.text
	batt_text.text = battery_tree.text
	cargo_text.text = cargo_tree.text
	hull_text.text = hull_tree.text
	scoop_text.text = scoop_tree.text


func _close_menu() -> void:
	Signals.ToggleDisplay.emit("play_ui", previous, true)
	Signals.VesselCanMove.emit()


func _toggle_display(to_toggle:String, _previous:String, is_displayed:bool = true) -> void:
	if to_toggle == id:
		_update_upgrades()
		previous = _previous
		visible = is_displayed
	else:
		hide()


func _update_upgrades() -> void:
	for each in all_upgrades:
		each.update_costs()