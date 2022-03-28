extends CanvasLayer

func _ready():
	$Gems.text = String(Global.gems)

func _on_gem_collected():
	Global.gems += 1
	_ready()
