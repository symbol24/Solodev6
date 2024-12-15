class_name UpgradeData extends Resource


@export var id:String
@export var title:String
@export var text:String
@export var costs:Array[CostData]
@export var prerequisists:Array[UpgradeData]
@export var texture:CompressedTexture2D

@export var purchased:bool = false

@export var data:Dictionary = {}

var can_be_purchased:bool:
	get:
		can_be_purchased = true
		for each in prerequisists:
			if not each.purchased: can_be_purchased = false
		return can_be_purchased


func get_cost_dict() -> Dictionary:
	var trash:int = 0
	var debris:int = 0
	for each in costs:
		if each.type == TnD.Type.TRASH:
			trash += each.amount
		else:
			debris += each.amount

	return {
			"trash":trash,
			"debris":debris
			}