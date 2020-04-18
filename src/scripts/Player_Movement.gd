extends KinematicBody2D

const WALK_SPEED = 100
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
		$body.speed_scale = 2
		$body.flip_h = false
		$body.set_offset(Vector2(6, 0))
		$armFront.show()
		$armBack.hide()
		$body.play("Walk")
	elif Input.is_action_pressed("left"):
		$body.speed_scale = 2
		$body.flip_h = true
		$body.set_offset(Vector2(-6, 0))
		$armBack.set_offset(Vector2(-10, 0))
		$armFront.hide()
		$armBack.show()
		$armBack.flip_h = true
		$body.play("Walk")
	elif Input.is_action_just_pressed("jump"):
		$body.speed_scale = 1
		$body.play("Jump")
	elif is_on_floor():
		$body.speed_scale = 1
		$body.play("idle")

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = WALK_SPEED
	elif Input.is_action_pressed("left"):
		velocity.x = -WALK_SPEED
	else:
		velocity.x = 0
	
	# apply gravity
	velocity.y += delta * GRAVITY
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	# check if player is airborne
	if is_on_floor() and Input.is_action_just_pressed('jump'):
		velocity.y = -JUMP_SPEED


