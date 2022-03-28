extends Button

# When button is pressed, go to menu screen
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://TitleMenu.tscn")
