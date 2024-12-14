class_name WaterCell extends Resource


var coords:Vector2i
var current_temp:int = WaterManager.NEUTRALTEMP
var new_temp:int = WaterManager.NEUTRALTEMP:
	get:
		new_temp = WaterManager.NEUTRALTEMP
		for each in affected_by:
			new_temp += each["temp"]
		if new_temp < WaterManager.MINTEMP: return WaterManager.MINTEMP
		if new_temp > WaterManager.MAXTEMP: return WaterManager.MAXTEMP
		return new_temp
var affected_by:Array[Dictionary] = []


func add_temp_source(temp_source:TempSource, _override_temp:int = 1000) -> void:
	if not _has_source(temp_source):
		var temp:int = _override_temp if _override_temp != 1000 else temp_source.strength
		affected_by.append({
			"source": temp_source,
			"temp": temp
		})
	elif _has_source(temp_source):
		_update_temp_source(temp_source, _override_temp)


func _update_temp_source(temp_source:TempSource, _override_temp:int = 1000) -> void:
	if _has_source(temp_source):
		var temp:int = _override_temp if _override_temp != 1000 else temp_source.strength
		var source:Dictionary = _get_source(temp_source)
		if source.has("temp"): source["temp"] = temp


func _has_source(temp_source:TempSource) -> bool:
	for each in affected_by:
		if each["source"] == temp_source:
			return true
	return false


func _get_source(temp_source:TempSource) -> Dictionary:
	for each in affected_by:
		if each["source"] == temp_source:
			return each
	return {}