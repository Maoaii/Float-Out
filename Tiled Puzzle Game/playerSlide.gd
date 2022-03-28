extends KinematicBody2D

var velocity = Vector2(0, 0)
var canMove = true
var target = "wall"

export var SPEED = 400

func _physics_process(delta):
	if canMove:
		if Input.is_action_just_pressed("left"):
			velocity = Vector2(-SPEED, 0)
			canMove = false
		elif Input.is_action_just_pressed("right"):
			velocity = Vector2(SPEED, 0)
			canMove = false
		elif Input.is_action_just_pressed("up"):
			velocity = Vector2(0, -SPEED)
			canMove = false
		elif Input.is_action_just_pressed("down"):
			velocity = Vector2(0, SPEED)
			canMove = false
		
	
	
	
	move_and_slide(velocity, Vector2.UP)
	
	if velocity == Vector2(0, velocity.y) and velocity.y < 0:
		$Sprite.rotation_degrees = 180
	elif velocity == Vector2(0, velocity.y) and velocity.y > 0:
		$Sprite.rotation_degrees = 0
	elif velocity == Vector2(velocity.x, 0) and velocity.x < 0:
		$Sprite.rotation_degrees = 90
	elif velocity == Vector2(velocity.x, 0) and velocity.x > 0:
		$Sprite.rotation_degrees = -90
	
	
	if velocity == Vector2(velocity.x, 0) and is_on_wall():
		canMove = true
	elif velocity == Vector2(0, velocity.y) and (is_on_ceiling() or is_on_floor()):
		canMove = true


func dead():
	get_tree().change_scene("res://Level1.tscn")
