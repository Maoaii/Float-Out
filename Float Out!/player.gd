extends KinematicBody2D

var velocity = Vector2(0, 0)

const SPEED = 250
const STRAFING_SPEED = 200
const POUND_SPEED = 40
const JUMP_FORCE = 450
const GRAVITY = 7
const SMOOTHING_FACTOR = 0.4

func _physics_process(delta):
	# Keep jumping trajectory when on air
	if not is_on_floor():
		$Sprite.play("air")    # Play airborne animation
		
		# Move right while airborne
		if Input.is_action_pressed("right"):
			velocity.x = STRAFING_SPEED
			$Sprite.flip_h = false    # Flip the character horizontally
		# Move left while airborne
		elif Input.is_action_pressed("left"):
			velocity.x = -STRAFING_SPEED
			$Sprite.flip_h = true    # Flip the character horizontally
		# Pound to the ground, increassing falling speed
		if Input.is_action_pressed("down"):
			velocity.y += POUND_SPEED
			$Sprite.play("pounding")
			# Smooth out the mommentum when player is not pressing down anymore
			if Input.is_action_just_released("down"):
				velocity.y = velocity.y + GRAVITY
	else:
		# Move right
		if Input.is_action_pressed("right"):
			velocity.x = SPEED
			$Sprite.play("walk")    # Play walking animation
			$Sprite.flip_h = false    # Flip the character horizontally
		# Move left
		elif Input.is_action_pressed("left"):
			velocity.x = -SPEED
			$Sprite.play("walk")    # Play walking animation
			$Sprite.flip_h = true    # Flip the character horizontally
		else:
			$Sprite.play("idle")    # Play idle animation
	
	# Gravity
	velocity.y = velocity.y + GRAVITY
	
	# Move character sideways
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_FORCE
		$SoundJump.play()
	
	# Make character come to a stop smoothly
	velocity.x = lerp(velocity.x, 0, SMOOTHING_FACTOR)



# Function that detects when the player entered a fall zone
func _on_Fall_Zone_body_entered(body):
	# Checks if the player touched it
	if body.get_name() == "player":
		# Goes to game over screen
		ouch(position.x)
		

# Bounces the player when falls on enemy head's
func bounce():
	velocity.y = -JUMP_FORCE * 0.4

# Makes the player jump up and back and change color when hit by an enemy
func ouch(var enemyXPos):
	# Changes player color
	set_modulate(Color(1, 0.3, 0.3, 0.4))
	
	# Make player jump up
	velocity.y = -JUMP_FORCE * 0.3
	
	# Makes player jump left or right
	if position.x < enemyXPos:
		velocity.x = -JUMP_FORCE * 2
	elif position.x > enemyXPos:
		velocity.x = JUMP_FORCE * 2
	
	# Disables player movement
	Input.action_release("left")
	Input.action_release("right")
	
	# Play hurt sound
	$SoundHurt.play()
	
	# Start timer
	$Timer.start()


# When timer runs out, goes to game over scene
func _on_Timer_timeout():
	var currentSceneName = get_tree().get_current_scene().filename
	get_tree().change_scene(currentSceneName)
	Global.gems = Global.gemsStart
