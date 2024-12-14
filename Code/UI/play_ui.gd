class_name PlayUi extends RiDControl


@onready var trash_label: Label = %trash_label
@onready var debris_label: Label = %debris_label


func _ready() -> void:
	super()
	Signals.TnDCollected.connect(_update_tnd)


func _update_tnd(type:TnD.Type, value:int) -> void:
	match type:
		TnD.Type.TRASH:
			trash_label.text = str(value)
		_:
			debris_label.text = str(value)