class_name Base extends RiDBuilding


@onready var label: Label = %label
@onready var timer: Timer = %timer


func _ready() -> void:
	super()
	timer.timeout.connect(_timer_timeout)


func _building_entered(body) -> void:
	if body is Vessel:
		body.enter_base()


func _timer_timeout() -> void:
	label.hide()