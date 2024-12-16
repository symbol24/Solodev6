extends Button


func _pressed() -> void:
	Signals.TnDSpawned.emit()