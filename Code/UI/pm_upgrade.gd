class_name PMUpgrade extends Control


@onready var image: TextureRect = %image
@onready var title: Label = %title
@onready var panel: PanelContainer = %panel
@onready var text: Label = %text


func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func set_values(texture:CompressedTexture2D, _title:String, _text:String) -> void:
	if texture != null:
		image.texture = texture
	title.text = _title
	text.text = _text


func _mouse_entered() -> void:
	panel.show()


func _mouse_exited() -> void:
	panel.hide()