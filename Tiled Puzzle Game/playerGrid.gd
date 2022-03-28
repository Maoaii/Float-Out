extends Area2D

onready var ray = $RayCast2D
onready var sprite = $Sprite
onready var tween = $Tween

var tile_size = 32

export var speed = 3

# Input dictionary
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

# Dictionary to keep track of how to rotate the sprite with movement
var rotations = {"right": -90,
			"left": 90,
			"up": 180,
			"down": 0}


func _ready():
	# Snaps the position to the nearest tile
	position = position.snapped(Vector2.ONE * tile_size)
	# Centers the character on the tile
	position += Vector2.ONE * tile_size/2

# When there's an input that isn't handled by _input
func _unhandled_input(event):
	# While tween is active, don't handle input
	if tween.is_active():
		return
	# Iterate through the input keys
	for dir in inputs.keys():
		# If the key pressed matches an input in the dictionary
		if event.is_action_pressed(dir):
			move(dir)
			rotateSprite(dir)

func move(dir):
	# Ray casts to the tile in the direction that was inputed
	ray.cast_to = inputs[dir] * tile_size
	
	# Using "cast_to" doesn't update the physics collider until the next frame
	# "force_raycast_update()" forces the raycast state to be updated
	ray.force_raycast_update()
	
	# Move character in desired direction if the raycast didin't collide
	if !ray.is_colliding():
		# Use commented version if you want a "teleport" movement
		# position += inputs[dir] * tile_size
		move_tween(inputs[dir])
	

# Rotate the sprite according to movement direction
func rotateSprite(dir):
	sprite.rotation_degrees = rotations[dir]

# Makes the movement smoother (idk how this works
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

