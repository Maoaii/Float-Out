extends KinematicBody2D

export var SPEED = 200

var tile_size = 32

var velocity = Vector2()
var player = null
var target_angle = null
var target_dir = null
var direction = null
var canMove = true

# Input dictionary
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}


func _physics_process(delta):
	velocity = Vector2.ZERO
	if player and canMove:
		target_angle = position.direction_to(player.position).angle()
		target_dir = Vector2(cos(target_angle), sin(target_angle))
		
		if (abs(target_dir.x) >= abs(target_dir.y)):
			if (target_dir.x > 0):
				direction = "right"
			else:
				direction = "left"
		else:
			if (target_dir.y > 0):
				direction = "down"
			else:
				direction = "up"
	canMove = false
	move_ai_towards(direction)
	


func move_ai_towards(direction):
	if direction == "left":
		velocity = Vector2(-SPEED, 0)
	elif direction == "right":
		velocity = Vector2(SPEED, 0)
	elif direction == "up":
		velocity = Vector2(0, -SPEED)
	else:
		velocity = Vector2(0, SPEED)
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		canMove = true

func _on_PlayerDetection_body_entered(body):
	player = body

func _on_PlayerDetection_body_exited(body):
	player = null
