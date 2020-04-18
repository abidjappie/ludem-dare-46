extends KinematicBody2D

const WALK_SPEED = 1000
const WALK_MAX_SPEED = 150
const STOP_FORCE = 800
const JUMP_SPEED = 400
const GRAVITY = 700

var velocity = Vector2()

func _physics_process(delta):
	# clamp the maximum horizontal movement speed
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	
	# apply gravity
	velocity.y += delta * GRAVITY
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

