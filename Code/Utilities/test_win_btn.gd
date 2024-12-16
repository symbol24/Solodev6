extends Button


func _pressed() -> void:
	Signals.Won.emit()