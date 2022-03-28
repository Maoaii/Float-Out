extends KinematicBody2D

var velocity = Vector2(0, 0)
export var speed = 100
export var direction = 1

func _ready():
	# If going right, flip the sprite
	if direction == 1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	# Make character bounce on walls and turn back
	if is_on_wall():
		direction = -direction
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	# Movement in the x-axis
	velocity.x = speed * direction
	
	# Let character move
	velocity = move_and_slide(velocity, Vector2.UP)


# When top_checker is touched
func _on_top_checker_body_entered(body):
	# Play dead animation
	$AnimatedSprite.play("dead")
	# Set enemy speed to 0
	speed = 0
	# Remove this enemy from collision detection
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	# Remove this enemy's checkers from collision detection
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$side_bot_checker.set_collision_layer_bit(4, false)
	$side_bot_checker.set_collision_mask_bit(0, false)
	# Start a timer to destroy the enemy
	$Timer.start()
	# Make the body that touched the enemy bounce
	body.bounce()
	# Play death sound
	$soundDead.play()
	
# When player touches this enemy from the sides or bottom
func _on_side_bot_checker_body_entered(body):
	if body.get_name() == "player":
		body.ouch(position.x)    # Send to the player object this enemy's x position

# When timer runs out, destroy this object
func _on_Timer_timeout():
	queue_free()
