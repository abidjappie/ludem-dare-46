extends Area2D

const WALK_SPEED = 90
const WALK_MAX_SPEED = 90
const STOP_FORCE = 800
const JUMP_SPEED = 400
const GRAVITY = 700
const OFFSET_Y = 28

var velocity = Vector2()
var player
var offset_y = OFFSET_Y
var following_distance
var seeking_objective = false
var current_objective = null
var target

var CHECKPOINTS = {}

onready var animateSprite = get_node("AnimatedSprite")
onready var objectives = get_node("../Objectives")

func seek_objective():
	current_objective = null
	for objective in objectives.objective_list:
		if position.distance_to(objective.position) < 128:
			current_objective = objective.position

func _ready():
	player = get_node("../Player_KinematicBody2D")
	target = player.position

func _physics_process(_delta):
	seek_objective()
	
	if current_objective:
		target = current_objective
		following_distance = 2
		offset_y = 0
	else:
		target = player.position
		following_distance = 64
		offset_y = OFFSET_Y
	
	var distance_from_target = position.distance_to(target)
	var height_from_target = Vector2(0, position.y).distance_to(Vector2(0, target.y))
	
	# If player is within range
	if (distance_from_target < 512 and distance_from_target > following_distance):
		if (target.x > position.x):
			velocity.x = WALK_SPEED
			animateSprite.flip_h = false
			animateSprite.set_offset(Vector2(3, 0))
		else:
			velocity.x = -WALK_SPEED
			animateSprite.flip_h = true
			animateSprite.set_offset(Vector2(-3, 0))
		if (position.y < target.y and height_from_target > offset_y): # pet above player 
			velocity.y = WALK_SPEED # move down
		elif (position.y > target.y and height_from_target > offset_y): # pet below player
			velocity.y = -WALK_SPEED # move up
	elif (distance_from_target < 64 && height_from_target < 24):
		if (target.x > position.x):
			animateSprite.flip_h = false
			animateSprite.set_offset(Vector2(3, 0))
		else:
			animateSprite.flip_h = true
			animateSprite.set_offset(Vector2(-3, 0))
		velocity.x = 0
		velocity.y = 0

	else:
		velocity.x = 0
		velocity.y = 0
		animateSprite.animation = "default"
	
	# clamp the maximum movement speed
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	velocity.y = clamp(velocity.y, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	position += velocity* _delta

# pet reached checkpoint
func _on_checkpoint_area_entered(area):
	if "Node2D" in area.get_name(): # check if area is a checkpoint
		CHECKPOINTS[area.get_name()] = true # ensures checkpoint only counted once
	print(CHECKPOINTS)
