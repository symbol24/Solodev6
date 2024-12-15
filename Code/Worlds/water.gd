class_name WaterManager extends TileMapLayer


const MAXTEMP:int = 10
const MINTEMP:int = 0
const NEUTRALTEMP:int = 5


@export var tic_interval:int = 3
@export var active:bool = true
@export var temp_increase_delay:float = 5.0
@export var use_propagation:bool = false

var tiles:Array[Vector2i]
var cells:Array[WaterCell] = []
var cells_dict:Dictionary
var temp_sources:Array = []
var removed_sources:Array = []

var current_interval:int = 0:
	set(value):
		current_interval = value
		if current_interval >= tic_interval:
			current_interval = 0
			_check_each_cell()
var timer_active:bool = true
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= temp_increase_delay:
			timer = 0.0
			_propagate_temp()

func _ready() -> void:
	tiles = get_used_cells()

	for each in tiles:
		var new:WaterCell = WaterCell.new()
		new.coords = each
		cells.append(new)
		cells_dict[new.coords] = new

	_update_temps()


func _process(delta: float) -> void:
	if use_propagation and timer_active: timer += delta


func _physics_process(_delta: float) -> void:
	if active: current_interval += 1


func _update_temps() -> void:
	timer_active = false
	temp_sources = get_tree().get_nodes_in_group("temp_source")
	for each:TempSource in temp_sources:
		var pos:Vector2i = to_local(each.global_position)
		pos.x /= 4
		pos.y /= 4
		var radius:int = each.strength if each.strength >= 0 else -each.strength
		_update_cells(pos, each, radius, each.strength)


func _update_cells(start_pos:Vector2i, temp_source:TempSource, radius:int, strength:int) -> void:
	var x:int = 0
	var y:int = 0
	x = start_pos.x - radius
	y = start_pos.y - radius
	while x <= start_pos.x + radius:
		while y <= start_pos.y + radius:
			var current_distance:int = Vector2(x, y).distance_squared_to(start_pos)
			var r_squared:int = pow(radius, radius)
			var root_dist:int = sqrt(current_distance)
			var current_str:int = mini(strength + root_dist, 0) if strength < 0 else maxi(strength - root_dist, 0)
			var cell:WaterCell = cells_dict[Vector2i(x,y)] if cells_dict.has(Vector2i(x,y)) else null
			if cell != null and temp_source != null and current_distance < r_squared:
				cell.add_temp_source(temp_source, current_str)
			y += 1
		await get_tree().process_frame
		y = start_pos.y - radius
		x += 1
	timer_active = true


func _check_each_cell() -> void:
	for each in cells:
		if each.current_temp != each.new_temp:
			set_cell(each.coords, 2, Vector2i(each.new_temp, 0))
			each.current_temp = each.new_temp


func _get_cell(coord:Vector2i) -> WaterCell:
	for each in cells:
		if each.coords == coord:
			return each
	return null


func _propagate_temp() -> void:
	_clear_nulls_in_sources()
	for each in temp_sources:
		if each != null: each.increase_strength()

	_update_temps()


func _clear_nulls_in_sources() -> void:
	var to_clear:Array[int] = []
	var i:int = 0
	while i < temp_sources.size():
		if temp_sources[i] == null:
			to_clear.append(i)
		i += 1
	to_clear.sort()
	to_clear.reverse()
	for each in to_clear:
		temp_sources.remove_at(each)
