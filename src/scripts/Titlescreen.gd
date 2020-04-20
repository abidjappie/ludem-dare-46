extends Node2D

onready var background = get_node("ParallaxBackground/AnimatedSprite")
onready var short_noise = get_node("Audio_ShortNoise")
onready var long_noise = get_node("Audio_LongNoise")
onready var fade_in = get_node("FadeIn_Tween")

export var START_VOLUME = -50
export var MAX_VOLUME = -14
export var fade_duration = 1
export var transition_type = 1 # TRANS_SINE

func _ready():
	long_noise.volume_db = START_VOLUME
	long_noise.play()
	fade_in.interpolate_property(long_noise, "volume_db", START_VOLUME, MAX_VOLUME,
	fade_duration, transition_type, Tween.EASE_IN,0)
	fade_in.start()
	background.play("1Init")
	yield(background, "animation_finished")
	background.play("2Loading")
	yield(background, "animation_finished")
	background.play("3DiskOK")
	yield(background, "animation_finished")
	short_noise.play()
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
