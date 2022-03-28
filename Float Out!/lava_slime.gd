extends KinematicBody2D


func _ready():
	pass


func _physics_process(delta):
	$AnimationPlayer.play("wobble")

# When top_checker is touched
func _on_top_checker_body_entered(body):
	# Play dead animation
	$AnimationPlayer.play("dead")
	$Sprite.play("dead")
	# Remove this enemy from collision detection
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	# Remove this enemy's checkers from collision detection
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_layer_bit(4, false)
	$sides_checker.set_collision_mask_bit(0, false)
	# Start a timer to destroy the enemy
	$Timer.start()
	# Make the body that touched the enemy bounce
	body.bounce()
	# Play death sound
	$soundDead.play()


# When sides_checker is touched
func _on_sides_checker_body_entered(body):
	if body.get_name() == "player":
		body.ouch(position.x)    # Send to the player object this enemy's x position

# When timer ends, delete this enemy
func _on_Timer_timeout():
	queue_free()
