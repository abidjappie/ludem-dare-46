extends Node2D

onready var background = get_node("ParallaxBackground/AnimatedSprite")

func _ready():
	print("playing 1")
	background.play("1Init")
	yield(background, "animation_finished")
	print("playing 2")
	background.play("2Loading")
	yield(background, "animation_finished")
	background.play("3DiskOK")
	yield(background, "animation_finished")
	background.play("46Flash")
	yield(background, "animation_finished")
	background.play("5PressStart")
	yield(background, "animation_finished")
	
func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		background.play("46Flash")
		yield(background, "animation_finished")
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://src/scenes/Default_Scene.tscn")
