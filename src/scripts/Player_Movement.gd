extends KinematicBody2D

const WALK_SPEED = 1000
const WALK_MAX_SPEED = 100
const STOP_FORCE = 800
const JUMP_SPEED = 270
const GRAVITY = 650

# the direction the player is looking
var look_direction = Vector2(1,0)

var velocity = Vector2()

onready var body = get_node("PlayerBodySprite")
onready var armFront = get_node("PlayerArmFrontSprite")
onready var armBack = get_node("PlayerArmBackSprite")

func ready():
	body.play("idle")
	body.speed_scale = 1
	armFront.visibility = true
	
func shoot():
	if Input.is_action_just_pressed("shoot"):
		if armFront.visible:
			armFront.play("Fire")
			yield(armFront, "animation_finished")
			armFront.play("Return")
			yield(armFront, "animation_finished")
			armFront.play("idle")
		else:
			armBack.play("Fire")
			yield(armBack, "animation_finished")
			armBack.play("Return")
			yield(armBack, "animation_finished")
			armBack.play("idle")

# play animations
func _process(_delta):
	shoot()
	if Input.is_action_pressed("right"):
		$PlayerBodySprite.speed_scale = 2
		$PlayerBodySprite.flip_h = false
		$PlayerArmFrontSprite.show()
		$PlayerArmBackSprite.hide()
		$PlayerBodySprite.play("Walk")
	elif Input.is_action_pressed("left"):
		$PlayerBodySprite.speed_scale = 2
		$PlayerArmFrontSprite.hide()
		$PlayerArmBackSprite.show()
		$PlayerBodySprite.flip_h = true
		$PlayerArmBackSprite.flip_h = true
		$PlayerBodySprite.play("Walk")
	elif Input.is_action_just_pressed("jump"):
		$PlayerBodySprite.speed_scale = 1
		$PlayerBodySprite.play("Jump")
	elif is_on_floor():
		$PlayerBodySprite.speed_scale = 1
		$PlayerBodySprite.play("idle")

func _physics_process(delta):
	var walk = WALK_SPEED * (Input.get_action_strength("right") - Input.get_action_strength("left"))
	
	# slow the player down if they're not attempting to move
	if abs(walk) < WALK_SPEED:
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	
	# clamp the maximum horizontal movement speed
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	
	# apply gravity
	velocity.y += delta * GRAVITY
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	# check if player is airborne
	if is_on_floor() and Input.is_action_just_pressed('jump'):
		velocity.y = -JUMP_SPEED


