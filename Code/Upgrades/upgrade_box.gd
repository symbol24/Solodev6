class_name UpgradeBox extends Control


@export var data:UpgradeData

@onready var costs: HBoxContainer = %costs
@onready var trash_cost: Label = %trash_cost
@onready var trash_icon: TextureRect = %trash_icon
@onready var debris_cost: Label = %debris_cost
@onready var debris_icon: TextureRect = %debris_icon
@onready var outline: TextureRect = %outline
@onready var item_texture: TextureRect = %item_texture
@onready var title: Label = %title
@onready var panel: PanelContainer = %panel
@onready var text: Label = %text

var vessel:Vessel
var mouse_over:bool = false
var cost:Dictionary = {}


func _input(event: InputEvent) -> void:
	if mouse_over and event.is_action_pressed("mouse_left"):
		_attempt_purchase()


func _ready() -> void:
	Signals.VesselReady.connect(_vessel_ready)
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	if data != null:
		title.text = data.title
		var replacement:Array = []
		for each in data.data:
			replacement.append(str(data.data[each]))
		if replacement.is_empty():
			text.text = data.text
		else:
			data.text = data.text % replacement
			text.text = data.text
		if data.texture != null:
			item_texture.texture = data.texture
		if not data.purchased:
			cost = data.get_cost_dict()
			trash_cost.text = "0/" + str(cost["trash"])
			debris_cost.text = "0/" + str(cost["debris"])
		else:
			costs.hide()
	Signals.UpgradeBoxReady.emit(self)


func update_costs() -> void:
	if vessel and not data.purchased:
		if cost["trash"] != 0:
			trash_cost.show()
			trash_icon.show()
			trash_cost.text = str(vessel.collected_trash) + "/" + str(cost["trash"])
		else:
			trash_cost.hide()
			trash_icon.hide()
		if cost["debris"] != 0:
			debris_cost.show()
			debris_icon.show()
			debris_cost.text = str(vessel.collected_debris) + "/" + str(cost["debris"])
		else:
			debris_cost.hide()
			debris_icon.hide()
		item_texture.modulate = Color.DARK_GRAY
		
		if not data.can_be_purchased:
			item_texture.modulate = Color.BLACK


func _mouse_entered() -> void:
	if not data.purchased and data.can_be_purchased:
		mouse_over = true
		if Data.upgrade_outline_hover != null:
			outline.texture = Data.upgrade_outline_hover
	panel.show()


func _mouse_exited() -> void:
	mouse_over = false
	if Data.upgrade_outline_normal != null:
		outline.texture = Data.upgrade_outline_normal
	panel.hide()


func _attempt_purchase() -> void:
	if vessel:
		if vessel.collected_debris >= cost["debris"] and vessel.collected_trash >= cost["trash"]:
			_complete_purchase()


func _complete_purchase() -> void:
	Signals.UpgradePurchased.emit(data)
	data.purchased = true
	item_texture.modulate = Color.WHITE
	costs.hide()
	Signals.UpdateUpgradeBoxes.emit()


func _vessel_ready(_vessel:Vessel) -> void:
	vessel = _vessel
