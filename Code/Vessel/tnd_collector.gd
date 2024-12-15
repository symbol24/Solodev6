class_name TnDCollector extends Area2D


@onready var tnd_collector_collider: CollisionShape2D = %tnd_collector_collider
@onready var vessel:Vessel = get_parent()


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area is TnD:
		var collected:Dictionary = area.get_tnd_dict()
		if vessel == null: vessel = get_parent()

		var can_pickup:bool = false
		match collected["type"]:
			TnD.Type.TRASH:
				if vessel.collected_trash < vessel.trash_capacity:
					can_pickup = true
			_:
				if vessel.collected_debris < vessel.debris_capacity:
					can_pickup = true

		if can_pickup: 
			vessel.add_tnd(collected["type"], collected["value"])
			area.pickup()
		
		