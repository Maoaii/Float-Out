extends Area2D


func _on_Area2D_body_entered(body):
	if body.get_name() == "playerSlide":
		body.dead()
