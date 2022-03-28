extends Button

# When button is pressed, change to first level
func _on_PlayButton_pressed():
	get_tree().change_scene("res://Level1.tscn")
