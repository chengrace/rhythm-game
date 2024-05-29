extends Camera2D

@export var camera_on = false
@export var speed = 100

func _physics_process(delta):
	if camera_on:
		position += Vector2(speed * delta, 0) # Moves the camera right every fram
