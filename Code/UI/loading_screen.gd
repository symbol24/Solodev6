class_name LoadingScreen extends RiDControl


const MAX:int = 20

@export var trash:CompressedTexture2D
@export var debris:CompressedTexture2D
@export var text_delay:float = 1.0

@onready var stuff_layer: Control = %stuff_layer
@onready var loading_text: Label = %loading_text

var active:bool = false
var current_ammount:int = 0
var pool:Array = []

var current_char:int = 0:
	set(value):
		current_char = value
		if current_char > max_char:
			current_ammount = 1
var max_char:int = 10
var text_timer:float = 0.0:
	set(value):
		text_timer = value
		if text_timer >= text_delay:
			text_timer = 0.0
			_show_next_char()


func _ready() -> void:
	super()


func _process(delta: float) -> void:
	if active:
		text_timer += delta


func _toggle_display(to_toggle:String, _previous:String, is_displayed:bool = true) -> void:
	if to_toggle == id:
		previous = _previous
		visible = is_displayed
		active = true
		current_char = 1
	else:
		hide()
		active = false


func _show_next_char() -> void:
	current_char += 1
	loading_text.visible_characters = current_char