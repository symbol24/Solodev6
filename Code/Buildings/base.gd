class_name Base extends RiDBuilding


func _building_entered(body) -> void:
	if body is Vessel:
		body.enter_base()
