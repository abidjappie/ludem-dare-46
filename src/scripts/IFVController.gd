extends KinematicBody2D

const WALK_SPEED = 1000
const WALK_MAX_SPEED = 150
const STOP_FORCE = 800
const JUMP_SPEED = 400
const GRAVITY = 700

var is_alive = true
var HEALTH = 3

var animation = ['Move', 'Fire']
var velocity = Vector2()
var player

func _ready():
	player = get_node("../Player_KinematicBody2D")

func _physics_process(delta):
	if is_alive:
		var distance_from_player = position.distance_to(player.position)
		var height_from_player = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
		
		# If player is within range
		if (distance_from_player < 128 && distance_from_player > 64):
			if (player.position.x > position.x):
				velocity.x = 10
				if ($body.animation != "Move"):
					$body.animation = "Move"
				$body.flip_h = false
				$turret.flip_h = false
				$body.set_offset(Vector2(3, -4))
				$turret.set_offset(Vector2(-3, -11))
			else:
				velocity.x = -10
				if ($body.animation != "Move"):
					$body.animation = "Move"
				$body.flip_h = true
				$turret.flip_h = true
				$body.set_offset(Vector2(-3, -4))
				$turret.set_offset(Vector2(3, -11))
		else:
			velocity.x = 0
			$body.stop()
			
		if (velocity.x!=0):
			$body.play()
		# clamp the maximum horizontal movement speed
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
		
		# apply gravity
		velocity.y += delta * GRAVITY
		
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		
		position += velocity * delta
	if HEALTH <= 0:
		die()

# kill this enemy
func die():
	is_alive = false
	# play animations
	queue_free() # destroy

func _on_bullet_area_entered(area):
	if (area.get_name() == "bullet" and area.from_who=="player"):
		HEALTH -= 1
