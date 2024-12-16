class_name TnDCollectedIcon extends Control


@export var height:float = 10
@export var life_time:float = 1.5

@onready var trash: TextureRect = %trash
@onready var debris: TextureRect = %debris


func spawn(type: TnD.Type) -> void:
	if type == TnD.Type.TRASH: debris.hide()
	else: trash.hide()

	var tween:Tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y-height), life_time)
	await tween.finished
	queue_free()