class_name Vessel extends RigidBody2D


@export var start_speed:float = 400
@export var start_trash_cap:int = 5
@export var start_debris_cap:int = 5
@export var start_battery:int = 100
@export var start_recharge_rate:int = 5
@export var start_deplete_rate:int = 2

@onready var tnd_collector_collider: CollisionShape2D = %tnd_collector_collider
@onready var battery_timer: Timer = %battery_timer
@onready var battery: TextureProgressBar = %battery
@onready var battery_icon: TextureRect = %battery_icon
@onready var recharge_area: Area2D = %recharge_area
@onready var icon_animator: AnimationPlayer = %icon_animator

var direction:Vector2 = Vector2.ZERO

# Stats
var extra_speed:float = 0
var speed:int: 
	get: return start_speed + extra_speed
var extra_trash_cap:int = 0
var trash_capacity:int = start_trash_cap:
	get: return start_trash_cap + extra_trash_cap
var extra_debris_cap:int = 0
var debris_capacity:int:
	get: return start_debris_cap + extra_debris_cap
var start_scoop:Vector2i
var extra_scoop_size:Vector2i = Vector2i.ZERO
var scoop_size:Vector2i = start_scoop + extra_scoop_size
var extra_battery:int = 0
var max_battery:int:
	get: return start_battery + extra_battery
var current_battery:int = start_battery:
	set(value):
		current_battery = value
		battery.max_value = max_battery
		battery.value = current_battery
var extra_recharge_rate:int = 0
var recharge_rate:int:
	get: return start_recharge_rate + extra_recharge_rate if recharging else 0
var extra_deplete_rate:int = 0
var deplete_rate:int:
	get: return start_deplete_rate + extra_deplete_rate
var extra_damp:float = 0.0

var active_upgrades:Array[UpgradeData] = []

# collected tnd
var collected_trash:int = 0
var collected_debris:int = 0

# conditions
var battery_dead:bool = false
var can_move:bool = true
var recharging:bool = false


func _ready() -> void:
	recharge_area.area_entered.connect(_area_entered)
	recharge_area.area_exited.connect(_area_exited)
	Signals.VesselCanMove.connect(_exit_base_menu)
	Signals.UpgradePurchased.connect(_upgrade_purchased)
	battery_timer.timeout.connect(_battery_timeout)
	start_scoop = Vector2(tnd_collector_collider.shape.radius, tnd_collector_collider.shape.height)
	current_battery = start_battery
	battery_timer.start()
	Signals.VesselReady.emit(self)
	

func _physics_process(_delta: float) -> void:
	if can_move:
		if not battery_dead:
			direction = Input.get_vector("left", "right", "up", "down")
		else:
			direction = Vector2.UP / 2
		apply_central_force(direction * speed)


func add_tnd(type:TnD.Type, value:int) -> void:
	match type:
		TnD.Type.TRASH:
			collected_trash += value
			Signals.TnDCollected.emit(type, collected_trash, trash_capacity)
		_:
			collected_debris += value
			Signals.TnDCollected.emit(type, collected_debris, debris_capacity)


func enter_base() -> void:
	can_move = false
	Signals.ToggleDisplay.emit("base_menu", "play_ui", true)


func _exit_base_menu() -> void:
	can_move = true


func _update_scoop_size() -> void:
	tnd_collector_collider.shape.radius = scoop_size.x
	tnd_collector_collider.shape.height = scoop_size.y


func _battery_timeout() -> void:
	if can_move:
		current_battery -= deplete_rate if not recharging else -recharge_rate
		if current_battery <= 0:
			current_battery = 0
			if not battery_dead: _battery_dead()
		elif current_battery >= max_battery:
			if battery_dead: _battery_refreshed()
			current_battery = max_battery


func _battery_dead() -> void:
	battery_dead = true
	_toggle_icon("battery", true)


func _battery_refreshed() -> void:
	battery_dead = false
	_toggle_icon("battery", false)


func _area_entered(area:Area2D) -> void:
	if area.is_in_group("recharge_area"):
		recharging = true


func _area_exited(area:Area2D) -> void:
	if area.is_in_group("recharge_area"):
		recharging = false


func _toggle_icon(icon_id:String, toggle_on:bool) -> void:
	match icon_id:
		"battery":
			if toggle_on:
				icon_animator.play("battery")
			else:
				icon_animator.play("RESET")
		_:
			pass


func _upgrade_purchased(upgrade:UpgradeData) -> void:
	var cost:Dictionary = upgrade.get_cost_dict()
	collected_trash -= cost["trash"]
	collected_debris -= cost["debris"]

	var keys = upgrade.data.keys()
	for k in keys:
		print("checking ", k)
		if get(k) != null:
			var value = get(k)
			set(k, value + upgrade.data[k])
			print("updated ", k, " with ", upgrade.data[k], " new value: ", get(k))