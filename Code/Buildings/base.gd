class_name Base extends RiDBuilding


func _building_entered(body) -> void:
	print(body.name, " entered base")
	if body is Vessel:
		body.enter_base()


func _building_exited(body) -> void:
	print(body.name, " exited base")