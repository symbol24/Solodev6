class_name TnDCollector extends Area2D


@onready var tnd_collector_collider: CollisionShape2D = %tnd_collector_collider
@onready var vessel:Vessel = get_parent()


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area is TnD:
		var collected:Dictionary = area.pickup()
		if vessel == null:
			vessel = get_parent()
		vessel.add_tnd(collected["type"], collected["value"])
		
		