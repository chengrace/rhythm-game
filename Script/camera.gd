extends Camera2D

func _physics_process(delta):
	position += Vector2(100 * delta, 0) # Moves the camera right every fram
