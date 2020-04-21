extends KinematicBody2D

var player
var npc_id
var rng = RandomNumberGenerator.new()
var velocity = Vector2()

const GRAVITY = 700

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player_KinematicBody2D")
	rng.randomize()
	npc_id = rng.randi_range(1, 32)
	
func _physics_process(delta):
		var distance_from_player = position.distance_to(player.position)
		var _height_from_player = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
		
		# If player is within range
		if (distance_from_player < 128):
			if ($AnimatedSprite.animation != ("Walk_"+str(npc_id))):
					$AnimatedSprite.animation = "Walk_"+str(npc_id)
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
			if (player.position.x < position.x):
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.set_offset(Vector2(3, 0))
				velocity.x = -10
			else:
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.set_offset(Vector2(-3, 0))
				velocity.x = 10
			velocity.x = 0
			$AnimatedSprite.animation = "Idle_"+str(npc_id)
		
		# apply gravity
		velocity.y += delta * GRAVITY
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		position += velocity * delta
