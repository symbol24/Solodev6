class_name RiDBuilding extends Area2D


@export var id:String


func _ready() -> void:
	body_entered.connect(_building_entered)
	body_exited.connect(_building_exited)


func _building_entered(_body) -> void:
	pass


func _building_exited(_body) -> void:
	pass