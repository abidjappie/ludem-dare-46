extends KinematicBody2D

const WALK_SPEED = 1000
const WALK_MAX_SPEED = 150
const STOP_FORCE = 800
const JUMP_SPEED = 400
const GRAVITY = 700
const BULLET_SPEED = 400
const VISION = 140
const RANGE = 110
const RANGE_T = 120
const BLINDSPOT = 64

var has_person = true
var is_alive = true
var HEALTH = 3

var animation = ['Move', 'Fire']
var velocity = Vector2()
var player

var shooting = false
var shooting_t = false
var reversing = false

const scn_bullet = preload("res://src/scenes/bullet.tscn")

func _ready():
	player = get_node("../Player_KinematicBody2D")

func _physics_process(delta):
	if is_alive:
		var distance_from_player = position.distance_to(player.position)
		var height_from_player = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
		
		# If player is within range
		if (distance_from_player < VISION && distance_from_player > RANGE):
			if (player.position.x > position.x):
				velocity.x = 10
				$body.flip_h = false
				$turret.flip_h = false
				$body.set_offset(Vector2(3, -4))
				$turret.set_offset(Vector2(-3, -11))
			else:
				velocity.x = -10
				$body.flip_h = true
				$turret.flip_h = true
				$body.set_offset(Vector2(-3, -4))
				$turret.set_offset(Vector2(3, -11))
			reversing = false
		elif (distance_from_player < RANGE && distance_from_player > BLINDSPOT && height_from_player < 16):
			if (player.position.x > position.x):
				$body.flip_h = false
				$turret.flip_h = false
				$body.set_offset(Vector2(3, -4))
				$turret.set_offset(Vector2(-3, -11))
			else:
				$body.flip_h = true
				$turret.flip_h = true
				$body.set_offset(Vector2(-3, -4))
				$turret.set_offset(Vector2(3, -11))
			velocity.x = 0
			if ($body.animation != "Fire"):
					$body.animation = "Fire"
					$body.play()
					$body.set_speed_scale(0.75)
		elif (distance_from_player < BLINDSPOT && height_from_player < 16):
			if (player.position.x > position.x):
				velocity.x = -10
				$body.flip_h = false
				$turret.flip_h = false
				$body.set_offset(Vector2(3, -4))
				$turret.set_offset(Vector2(-3, -11))
			else:
				velocity.x = 10
				$body.flip_h = true
				$turret.flip_h = true
				$body.set_offset(Vector2(-3, -4))
				$turret.set_offset(Vector2(3, -11))
			if !reversing:
				reversing = true
		else:
			velocity.x = 0
			if is_alive:
				$body.animation = "Move"
				$body.stop()
		
		if (distance_from_player < RANGE_T && height_from_player < 18):
			if ($turret.animation != "Fire"):
				$turret.animation = "Fire"
				$turret.play()
				$turret.set_speed_scale(1)
		else:
			$turret.animation = "Idle"
		
		if velocity.x != 0:
			if ($body.animation != "Move"):
				$body.play("Move", reversing)
				
		shoot("turret")
		shoot("body")
		
		# clamp the maximum horizontal movement speed
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
		
		# apply gravity
		velocity.y += delta * GRAVITY
		
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		
		position += velocity * delta

func shoot(from):
	var sprite = get_node(from)
	if (sprite.animation == "Fire"):	
		if sprite.get_frame() == 1 and ((from == "body" and !shooting) or (from == "turret" and !shooting_t)):
			var bullet = scn_bullet.instance()
			var bullet_height = 2
			if from == "body": 
				shooting = true
			if from == "turret": 
				shooting_t = true
				bullet_height = 8
			bullet.from_who = get_name()
			bullet.get_node("AnimatedSprite").animation = "bullet"
			bullet.position = get_node(".").position
			bullet.position.y -= bullet_height
			if sprite.flip_h:
				bullet.velocity.x = -BULLET_SPEED
			else:
				bullet.velocity.x = BULLET_SPEED
			$'..'.add_child(bullet)
		elif (sprite.get_frame() == 0):
			if from == "body": shooting = false
			if from == "turret": shooting_t = false


# kill this enemy
func die():
	is_alive = false
	# play animations
	queue_free() # destroy

func _on_bullet_area_entered(area):
	if (area.get_name() == "bullet" and area.from_who=="player"):
		HEALTH -= 1
