extends Control


func _ready():
	$soundWin.play()
	$GemsCollected.text = String(Global.gems)
	Global.gems = 0
	Global.gemsStart = 0
