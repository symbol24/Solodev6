class_name TnD extends Area2D


enum Type {
			TRASH = 0,
			DEBRIS = 1,
}

@export var type:Type
@export var free_time:float = 0.1

@onready var visuals: TileMapLayer = %visuals
@onready var pickup_collider: CollisionShape2D = %pickup_collider

var value:int = 1


func get_tnd_dict() -> Dictionary:
	var dict:Dictionary
	dict = {
			"type": type,
			"value": value,
		}
	return dict


func pickup() -> void:
	get_tree().create_timer(free_time).timeout.connect(_queue_free)


func _queue_free() -> void:
	queue_free.call_deferred()