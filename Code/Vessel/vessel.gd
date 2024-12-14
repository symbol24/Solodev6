class_name Vessel extends RigidBody2D


@export var acceleration:float = 500
@export var friction:float = 500
@export var speed:float = 400

var direction:Vector2 = Vector2.ZERO

# collected tnd
var collected_trash:int = 0
var collected_debris:int = 0

# conditions
var can_move:bool = true


func _ready() -> void:
	Signals.VesselCanMove.connect(_exit_base_menu)
	

func _process(_delta: float) -> void:
	if can_move:
		direction = Input.get_vector("left", "right", "up", "down")

		apply_central_force(direction * speed)


func add_tnd(type:TnD.Type, value:int) -> void:
	match type:
		TnD.Type.TRASH:
			collected_trash += value
			Signals.TnDCollected.emit(type, collected_trash)
		_:
			collected_debris += value
			Signals.TnDCollected.emit(type, collected_debris)

	print("added ", value, " to ", type)


func enter_base() -> void:
	can_move = false
	Signals.ToggleDisplay.emit("base_menu", "play_ui", true)


func _exit_base_menu() -> void:
	can_move = true