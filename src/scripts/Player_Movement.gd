extends KinematicBody2D

const WALK_SPEED = 100
const JUMP_SPEED = 270
const GRAVITY = 650
const BULLET_SPEED = 400
const BULLET_SPAWN_OFFSET = 16

var PLAYER_HEALTH = 10

const scn_bullet = preload("res://src/scenes/bullet.tscn")
# the direction the player is looking
var look_direction = Vector2(1,0)

var velocity = Vector2()

func ready():
	$body.play("idle")
	$body.speed_scale = 1
	$armFront.visibility = true
	
func shoot():
	if Input.is_action_just_pressed("shoot"):
		$shoot_audio.play()
		var bullet = scn_bullet.instance()
		bullet.from_who = "player"
		bullet.position = get_node(".").position
		bullet.position.y -= 5
		if $body.flip_h:
			bullet.position.x -= BULLET_SPAWN_OFFSET
			bullet.velocity.x = -BULLET_SPEED
		else:
			bullet.position.x += BULLET_SPAWN_OFFSET
			bullet.velocity.x = BULLET_SPEED
		$'..'.add_child(bullet)
		if $armFront.visible:
			$armFront.play("Fire")
			yield($armFront, "animation_finished")
			$armFront.play("Return")
			yield($armFront, "animation_finished")
			$armFront.play("idle")
		else:
			$armBack.play("Fire")
			yield($armBack, "animation_finished")
			$armBack.play("Return")
			yield($armBack, "animation_finished")
			$armBack.play("idle")
		$shoot_audio.stop()

# play animations
func _process(_delta):
	if PLAYER_HEALTH <= 0:
		die()
	shoot()
	if Input.is_action_pressed("right"):
		$body.speed_scale = 2
		$body.flip_h = false
		$body.set_offset(Vector2(6, 0))
		$armFront.show()
		$armBack.hide()
		if is_on_floor():
			$body.play("Walk")
		else:
			$body.play("Jump")
	elif Input.is_action_pressed("left"):
		$body.speed_scale = 2
		$body.flip_h = true
		$body.set_offset(Vector2(-6, 0))
		$armBack.set_offset(Vector2(-10, 0))
		$armFront.hide()
		$armBack.show()
		$armBack.flip_h = true
		if is_on_floor():
			$body.play("Walk")
		else:
			$body.play("Jump")
	elif Input.is_action_just_pressed("jump"):
		$body.speed_scale = 1
		$body.play("Jump")
		$jump_audio.play()
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

func die():
	print("Player died!")
	$body.play("Death")
	yield($body, "animation_finished")

func _on_damage_area_entered(area):
	if (area.get_name() == "SpikeArea2D"):
		PLAYER_HEALTH -= 10 # instant death
	if (area.get_name() == "bullet"):
		PLAYER_HEALTH -= 1
	#print("Player health: ",PLAYER_HEALTH)
