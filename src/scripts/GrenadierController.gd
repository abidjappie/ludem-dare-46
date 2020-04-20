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

func _ready():
	player = get_node("../Player_KinematicBody2D")
	is_alive = true

func _physics_process(delta):
	if is_alive:
		var distance_from_player = position.distance_to(player.position)
		var _height_from_player = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
		
		# If player is within range
		if (distance_from_player < 128 && distance_from_player > 64):
			if (player.position.x > position.x):
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.set_offset(Vector2(3, 0))
			else:
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.set_offset(Vector2(-3, 0))
		elif (distance_from_player < 64):
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
		else:
			velocity.x = 0
			if is_alive:
				$AnimatedSprite.animation = "Idle"
			
		
		# apply gravity
		velocity.y += delta * GRAVITY
		
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		
		position += velocity * delta

func _on_bullet_entered(area):
	is_alive = false
	if (area.get_name() == "bullet"):
		$AnimatedSprite.speed_scale = 1
		$AnimatedSprite.play("Death")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
