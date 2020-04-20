extends KinematicBody2D

const WALK_SPEED = 1000
const WALK_MAX_SPEED = 150
const STOP_FORCE = 800
const JUMP_SPEED = 400
const GRAVITY = 700
const BULLET_SPEED = 400
const VISION = 140
const RANGE = 110

var animation = ['Idle', 'Running', 'Fire', 'Death']
var velocity = Vector2()
var player
var is_alive

var shooting = false

const scn_bullet = preload("res://src/scenes/bullet.tscn")

func _ready():
	player = get_node("../Player_KinematicBody2D")
	is_alive = true

func _physics_process(delta):
	if is_alive:
		var distance_from_player = position.distance_to(player.position)
		var height_from_player = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
		
		
		# If player is within range
		if (distance_from_player < VISION && distance_from_player > RANGE):
			if (player.position.x > position.x):
				velocity.x = 10
				if ($AnimatedSprite.animation != "Running"):
					$AnimatedSprite.animation = "Running"
					$AnimatedSprite.play()
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.set_offset(Vector2(3, 0))
			else:
				velocity.x = -10
				if ($AnimatedSprite.animation != "Running"):
					$AnimatedSprite.animation = "Running"
					$AnimatedSprite.play()
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.set_offset(Vector2(-3, 0))
		elif (distance_from_player < RANGE && height_from_player < 16):
			if (player.position.x > position.x):
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.set_offset(Vector2(3, 0))
			else:
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.set_offset(Vector2(-3, 0))
			velocity.x = 0
			if ($AnimatedSprite.animation != "Fire"):
					$AnimatedSprite.animation = "Fire"
					$AnimatedSprite.play()
					$AnimatedSprite.set_speed_scale(1)
		else:
			velocity.x = 0
			if is_alive:
				$AnimatedSprite.animation = "Idle"
		
		if ($AnimatedSprite.animation == "Fire"):	
			if ($AnimatedSprite.get_frame() == 1 and !shooting):
				shooting = true
				shoot()
			elif ($AnimatedSprite.get_frame() == 0):
				shooting = false
		
		# clamp the maximum horizontal movement speed
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
		
		# apply gravity
		velocity.y += delta * GRAVITY
		
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		
		position += velocity * delta

func shoot():
	var bullet = scn_bullet.instance()
	bullet.from_who = get_name()
	bullet.get_node("AnimatedSprite").animation = "bullet"
	bullet.position = get_node(".").position
	bullet.position.y -= 2
	if $AnimatedSprite.flip_h:
		bullet.velocity.x = -BULLET_SPEED
	else:
		bullet.velocity.x = BULLET_SPEED
	$'..'.add_child(bullet)

# kill this enemy
func die():
	is_alive = false
	$AnimatedSprite.speed_scale = 1
	$AnimatedSprite.play("Death1")
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func _bullet_area_entered(area):
	if (area.get_name() == "bullet" and area.from_who=="player"):
		die()

# enemy enters spike area
func _on_spike_area_entered(area):
	if area.get_name() == "SpikeArea2D":
		die()
