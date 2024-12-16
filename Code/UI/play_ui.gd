class_name PlayUi extends RiDControl


@export var tnd_collected_icon:PackedScene

@onready var too_much: RichTextLabel = %too_much


func _ready() -> void:
	super()
	Signals.TnDCollected.connect(_spawn_tnd_icon)
	Signals.ToggleTnDWarning.connect(_toggle_too_much)


func _spawn_tnd_icon(type:TnD.Type, _value:int, _cap:int, pos:Vector2) -> void:
	var new:TnDCollectedIcon = tnd_collected_icon.instantiate()
	add_child(new)
	if not new.is_node_ready(): await new.ready
	new.global_position = pos
	new.spawn(type)


func _toggle_too_much(value:bool) -> void:
	too_much.visible = value