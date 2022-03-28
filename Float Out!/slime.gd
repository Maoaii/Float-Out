extends KinematicBody2D

# The "export" behind "var" makes it so I can change that variable in the inspector
var velocity = Vector2(0, 0)
export var direction = 1    # 1 is right, -1 is left
export var detects_cliffs = true
export var speed = 100

const GRAVITY = 7

func _ready():
	# If going right, flip the sprite
	if direction == 1:
		$AnimatedSprite.flip_h = true
	# Puts the raycast2d floor checker on the right or the left of
	# the collision shape, making the character able to detect cliffs
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	# If the character can detect cliffs, it will not fall
	$floor_checker.enabled = detects_cliffs
	
	# If this enemy can detect cliffs, it has a different color
	if detects_cliffs:
		set_modulate(Color(0.8, 0.8, 1))
	
func _physics_process(delta):
	# Make character bounce on walls and turn back
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction = -direction
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	# Gravity
	velocity.y += GRAVITY
	
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
	$sides_checker.set_collision_layer_bit(4, false)
	$sides_checker.set_collision_mask_bit(0, false)
	# Start a timer to destroy the enemy
	$Timer.start()
	# Make the body that touched the enemy bounce
	body.bounce()
	# Play death sound
	$soundDead.play()

# When side_checker is touched
func _on_sides_checker_body_entered(body):
	if body.get_name() == "player":
		body.ouch(position.x)    # Send to the player object this enemy's x position

# After the timer runs out, delete this enemy
func _on_Timer_timeout():
	queue_free()
