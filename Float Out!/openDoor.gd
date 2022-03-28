extends Area2D

# When player enters the door, switch to win screen
func _on_openDoor_body_entered(body):
	var sceneName = get_tree().get_current_scene().get_name()
	
	if sceneName == "Level1":
		get_tree().change_scene("res://Level2.tscn")
		Global.gemsStart = Global.gems
	elif sceneName == "Level2":
		get_tree().change_scene("res://Level3.tscn")
		Global.gemsStart = Global.gems
	elif sceneName == "Level3":
		get_tree().change_scene("res://WinScreen.tscn")
