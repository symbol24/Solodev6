class_name TempSource extends Marker2D


@export var starting_strength:int = 1
@export var increase_value:int = 0
@export var max_str:int = 2:
	get: 
		if starting_strength > 0: return max_str if max_str > starting_strength else starting_strength + 1
		if starting_strength < 0: return max_str if max_str < starting_strength else starting_strength - 1
		return 0
@export var active:bool = true
@export var use_max_strength:bool = true

var extra_str:int = 0
var strength:int:
	get: 
		if not active: return 0
		if use_max_strength:
			if starting_strength < 0:
				return starting_strength + extra_str if starting_strength + extra_str >= max_str else max_str
			elif starting_strength > 0:
				return starting_strength + extra_str if starting_strength + extra_str <= max_str else max_str
			return 0
		return starting_strength + extra_str


func increase_strength() -> void:
	extra_str += increase_value
	