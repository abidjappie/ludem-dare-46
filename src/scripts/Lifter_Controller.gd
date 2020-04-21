extends KinematicBody2D

const STOP_FORCE = 800
const JUMP_SPEED = 400
const GRAVITY = 700
const BULLET_SPEED = 400
const VISION = 140
const RANGE = 32

var velocity = Vector2()
var is_alive
var health = 15

var attacking = false
var hit = false

onready var death_audio = get_node("death_audio")
onready var player = get_node("../Player_KinematicBody2D")

func _ready():
	is_alive = true

func _physics_process(delta):
	if (health<1):
		die()
	if is_alive:
		if !$VisibilityNotifier2D.is_on_screen():
			if (position.x > player.position.x):
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.flip_h = true
				
		var distance_from_player = position.distance_to(player.position)
		var height_from_player = Vector2(0, position.y).distance_to(Vector2(0, player.position.y))
		var in_front = (player.position.x>position.x)==$AnimatedSprite.flip_h
		# If player is within range
		if (distance_from_player < RANGE and in_front):
			if !attacking:
				attack()
		elif (distance_from_player < VISION):
			if $AnimatedSprite.animation!="Moving":
				$AnimatedSprite.play("Moving", !in_front)
				$AnimatedSprite.set_speed_scale(0.5)
			move_toward_player()
			
		# apply gravity
		velocity.y += delta * GRAVITY
		
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		
		position += velocity * delta
		
		if (distance_from_player<32) and $AnimatedSprite.animation=="Attack" and in_front and !hit:
			player.take_damage(5)
			print("HIT")
			hit = true
			if player.position.x> position.x:
				player.position.x += 6
			if player.position.x< position.x:
				player.position.x -= 6

func attack():
	attacking = true
	$AnimatedSprite.set_speed_scale(0.75)
	$AnimatedSprite.play("Anticipate")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.set_speed_scale(2)
	$AnimatedSprite.play("Attack")
	yield($AnimatedSprite, "animation_finished")
	attacking = false
	hit = false
	
func move_toward_player():
	if (position.x > player.position.x):
		velocity.x = -10
	else:
		velocity.x = 10

# kill this enemy
func die():
	is_alive = false
	$AnimatedSprite.animation = "Idle"
	$AnimatedSprite.stop()
	death_audio.play()
	yield(death_audio, "finished")
	print("DIE")
	queue_free()

func _on_Area2D_area_entered(area):
		if (area.get_name() == "bullet" and area.from_who=="player"):
			health -= 1
		
