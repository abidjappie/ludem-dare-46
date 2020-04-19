extends KinematicBody2D

const WALK_SPEED = 90
const WALK_MAX_SPEED = 90
const STOP_FORCE = 800
const JUMP_SPEED = 400
const GRAVITY = 700

var velocity = Vector2()
var player
var offset_y = 28

onready var animateSprite = get_node("AnimatedSprite")

func _ready():
	player = get_node("../Player_KinematicBody2D")

func _physics_process(_delta):
	var distance_from_player = position.distance_to(player.position)
	var height_from_player = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
	
	# If player is within range
	if (distance_from_player < 512 and distance_from_player > 64):
		if (player.position.x > position.x):
			velocity.x = WALK_SPEED
			animateSprite.flip_h = false
			animateSprite.set_offset(Vector2(3, 0))
		else:
			velocity.x = -WALK_SPEED
			animateSprite.flip_h = true
			animateSprite.set_offset(Vector2(-3, 0))
		if (position.y < player.position.y and height_from_player > offset_y): # pet above player 
			velocity.y = WALK_SPEED # move down
		elif (position.y > player.position.y and height_from_player > offset_y): # pet below player
			velocity.y = -WALK_SPEED # move up
	elif (distance_from_player < 64 && height_from_player < 24):
		if (player.position.x > position.x):
			animateSprite.flip_h = false
			animateSprite.set_offset(Vector2(3, 0))
		else:
			animateSprite.flip_h = true
			animateSprite.set_offset(Vector2(-3, 0))
		velocity.x = 0
		velocity.y = 0

	else:
		velocity.x = 0
		velocity.y = 0
		animateSprite.animation = "default"
	
	# clamp the maximum movement speed
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	velocity.y = clamp(velocity.y, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	
	# apply gravity
	#velocity.y += delta * GRAVITY
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

