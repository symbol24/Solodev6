extends Node


# UI
signal ToggleDisplay(id:String, previous:String, display:bool)
signal TnDCollected(type:TnD.Type, amount:int)


# Vessel
signal VesselCanMove()


# Water
signal StrengthUpdated()