extends Node


# UI
signal ToggleDisplay(id:String, previous:String, display:bool)
signal TnDCollected(type:TnD.Type, amount:int, capacity:int)


# Vessel
signal VesselCanMove()
signal VesselReady(vessel:Vessel)


# Water
signal StrengthUpdated()


# Upgrades
signal UpgradePurchased(upgrade:UpgradeData)
signal UpgradeBoxReady(box:UpgradeBox)
signal UpdateUpgradeBoxes()