extends KinematicBody2D

const WALK_SPEED = 1000
const WALK_MAX_SPEED = 150
const STOP_FORCE = 800
const JUMP_SPEED = 400
const GRAVITY = 700

var animation = ['Idle', 'Running', 'Fire', 'Death']
var velocity = Vector2()
var player

var is_alive
var shooting = false

onready var collision = get_node("CollisionShape2D")

const scn_grenade = preload("res://src/scenes/grenade.tscn")

func _ready():
	player = get_node("../Player_KinematicBody2D")
	is_alive = true

func _physics_process(delta):
	if is_alive:
		var distance_from_player = position.distance_to(player.position)
		var _height_from_player = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
		
		# If player is within range
		if (distance_from_player < 152 && distance_from_player > 96):
			if (player.position.x > position.x):
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.set_offset(Vector2(3, 0))
			else:
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.set_offset(Vector2(-3, 0))
			velocity.x = 0
		elif (distance_from_player < 96 && distance_from_player > 64):
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
		elif (distance_from_player < 64):
			if ($AnimatedSprite.animation != "Running"):
					$AnimatedSprite.animation = "Running"
					$AnimatedSprite.play()
			if (player.position.x > position.x):
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.set_offset(Vector2(3, 0))
				velocity.x = -10
			else:
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.set_offset(Vector2(-3, 0))
				velocity.x = 10
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
		
		# apply gravity
		velocity.y += delta * GRAVITY
		
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		
		position += velocity * delta

func shoot():
	var grenade = scn_grenade.instance()
	grenade.from_who = get_name()
	
	grenade.target = player.position + Vector2(0, -8)
	if $AnimatedSprite.flip_h:
		grenade.position = get_node(".").position + Vector2(-10, -5)
		grenade.direction = -1
	else:
		grenade.position = get_node(".").position + Vector2(10, -5)
		grenade.direction = 1
	$'..'.add_child(grenade)

func _on_bullet_entered(area):
	if (area.get_name() == "bullet"):
		is_alive = false
		$AnimatedSprite.speed_scale = 1
		$AnimatedSprite.play("Death")
		collision.set_deferred("disabled", true) # disable collision
		yield($AnimatedSprite, "animation_finished")
		queue_free()
