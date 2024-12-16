class_name Boat extends Node2D


const XRANGE:Array[float] = [30, 610]
const DESPAWNRANGE:Array[float] = [-32, 672]


@export var speed:float = 40
@export var delay_range:Array[float] = [1, 4.0]
@export var spawn_range:Array[float] = [1, 3]

@onready var visuals: Sprite2D = %visuals
@onready var particle: CPUParticles2D = %particle

var direction:int = 1
var active:bool = false
var facing_left:bool = true
var manager:TnDManager

var timer_active:bool = false
var current_delay:float = 1
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= current_delay:
			timer = 0.0
			_spawn_tnd()


func _ready() -> void:
	_get_new_delay()


func _process(delta: float) -> void:
	if active:
		global_position.x = move_toward(global_position.x, global_position.x + direction, delta * speed)
		if timer_active: timer += delta
		if global_position.x <= DESPAWNRANGE[0] or global_position.x >= DESPAWNRANGE[1]:
			queue_free()


func activate(new_direction:int, _manager:TnDManager, texture:CompressedTexture2D = null) -> void:
	if new_direction < 0:
		visuals.flip_h = true
		particle.position.x = -particle.position.x
	direction = new_direction
	if texture:
		visuals.texture = texture
	active = true
	timer_active = true
	manager = _manager


func _spawn_tnd() -> void:
	timer_active = false
	if global_position.x >= XRANGE[0] or global_position.x <= XRANGE[1]:
		var amount:int = randi_range(spawn_range[0], spawn_range[1])
		for i in amount:
			var new_tnd:TnD
			var tnd_type:int = randi_range(0,1)
			if tnd_type == 1:
				new_tnd = Data.trash_scene.instantiate()
			else:
				new_tnd = Data.debris_scene.instantiate()
			if manager:
				manager.add_child(new_tnd)
				if not new_tnd.is_node_ready(): await new_tnd.ready
				new_tnd.global_position = global_position
				new_tnd.spawn(direction, manager)
				Signals.TnDSpawned.emit()
			await get_tree().create_timer(randf()).timeout

	_get_new_delay()
	timer_active = true
		

func _get_new_delay() -> void:
	current_delay = randf_range(delay_range[0], delay_range[1])
