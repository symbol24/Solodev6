class_name TnDManager extends Node2D

@export var boats:Array[CompressedTexture2D] = []
@export var boat_scene:PackedScene
@export var spawn_delay_range:Array[float] = [5, 20]

var active:bool = true
var current_delay:float = 1.0
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= current_delay:
			timer = 0.0
			_spawn_a_boat()


func _ready() -> void:
	_spawn_a_boat()
	current_delay = randf_range(spawn_delay_range[0], spawn_delay_range[1])


func _process(delta: float) -> void:
	if active: timer += delta


func _spawn_a_boat() -> void:
	active = false
	var side:int = randi_range(0,1)
	var direction:int = 1
	var pos:Vector2i = Vector2i(-16, 48)
	if side == 1:
		direction = -1
		pos = Vector2i(656, 48)
	var new_boat:Boat = boat_scene.instantiate()
	add_child(new_boat)
	new_boat.position = pos
	var i:int = randi_range(0, 2)
	var texture:CompressedTexture2D = boats[i-1] if i > 0 else null
	new_boat.activate(direction, self, texture)
	current_delay = randf_range(spawn_delay_range[0], spawn_delay_range[1])
	active = true


