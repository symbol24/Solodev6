class_name GameManager extends Node


@export var tnd_loss_count:int = 30
@export var warning_percent:float = 0.9

var all_upgrades:Array = []
var win_count:int = 0
var required_win_count:int = 0
var warning_count:int:
	get: return floori(tnd_loss_count * warning_percent)
var loss_count:int = 0:
	set(value):
		loss_count = value
		Signals.LossCountUpdated.emit(loss_count)
		if loss_count >= warning_count:
			Signals.ToggleTnDWarning.emit(true)
		else:
			Signals.ToggleTnDWarning.emit(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			Signals.ToggleDisplay.emit("play_ui", "pause_menu", true)
			get_tree().paused = false
		else:
			Signals.ToggleDisplay.emit("pause_menu", "play_ui", true)
			get_tree().paused = true



func _ready() -> void:
	Signals.AddToWinCon.connect(_add_to_win_con)
	Signals.TnDSpawned.connect(_add_to_loss_count)
	Signals.TnDCollected.connect(_remove_to_loss_count)
	Signals.LoadSceneComplete.connect(_start_game)
	all_upgrades = get_tree().get_nodes_in_group("upgrade_box")
	_check_required_win_con()


func _start_game(_id:String) -> void:
	Signals.ToggleDisplay.emit("play_ui", "", true)


func _check_required_win_con() -> void:
	for each in all_upgrades:
		if each.data.win_con: required_win_count += 1


func _add_to_win_con() -> void:
	win_count += 1
	if win_count >= required_win_count:
		Signals.Won.emit()


func _add_to_loss_count() -> void:
	loss_count += 1
	if loss_count >= tnd_loss_count:
		Signals.Lose.emit()


func _remove_to_loss_count(_type:TnD.Type, _amount:int, _cap:int, _pos:Vector2) -> void:
	loss_count -= 1