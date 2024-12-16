class_name TnD extends Area2D


enum Type {
			TRASH = 0,
			DEBRIS = 1,
}


const MAXYSPEED:float = 24.0
const GRAVITY:float = 20
const TRASHY: Array[float] = [64, 96]
const DEBRISY: Array[float] = [304, 336]
const XRANGE: Array[float] = [0, 640]


@export var type:Type
@export var free_time:float = 0.1
@export var x_speed:float = 10
@export var y_speed:float = -32

@onready var pickup_collider: CollisionShape2D = %pickup_collider

var value:int = 1
var active:bool = false
var x_direction:int = -1
var current_y:float = 0.0
var manager:TnDManager
var final_y:float
var bob:float = 0.0


func _ready() -> void:
	current_y = y_speed
	if type == Type.TRASH: final_y = randi_range(TRASHY[0], TRASHY[1])
	else: final_y = randi_range(DEBRISY[0], DEBRISY[1])


func _process(delta: float) -> void:
	if active and manager:
		if not position.x in XRANGE: x_direction = -x_direction
		position.x = move_toward(position.x, position.x - x_direction, delta * x_speed)
		
		position.y = move_toward(position.y, position.y + 1, delta * current_y)
		current_y += delta * GRAVITY
		current_y = min(current_y, MAXYSPEED)
		if position.y >= final_y: 
			active = false
			final_y = position.y

	elif not active and manager:
		position.y = final_y + sin(bob)
		bob += delta



func get_tnd_dict() -> Dictionary:
	var dict:Dictionary
	dict = {
			"type": type,
			"value": value,
		}
	return dict


func pickup() -> void:
	get_tree().create_timer(free_time).timeout.connect(_queue_free)


func spawn(direction:int, _manager:TnDManager) -> void:
	manager = _manager
	x_direction = direction
	active = true


func _queue_free() -> void:
	queue_free.call_deferred()