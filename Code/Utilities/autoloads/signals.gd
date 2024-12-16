extends Node


# Scene Manager
signal LoadScene(id:String, show_loading_screen:bool)
signal LoadSceneComplete(id:String)
signal LoadUi()
signal ClearActiveScene()


# UI
signal ToggleDisplay(id:String, previous:String, display:bool)
signal ToggleTnDWarning(display:bool)


# Vessel
signal VesselCanMove()
signal VesselReady(vessel:Vessel)


# Water
signal StrengthUpdated()


# Upgrades
signal UpgradePurchased(upgrade:UpgradeData)
signal UpgradeBoxReady(box:UpgradeBox)
signal UpdateUpgradeBoxes()
signal AddToWinCon()


# Game
signal Won()
signal Lose()
signal WorldReady(world:World)
signal LossCountUpdated(value:int)


# TnD
signal TnDSpawned()
signal TnDCollected(type:TnD.Type, amount:int, capacity:int, position:Vector2)