extends Node2D

onready var player = get_node("Player_KinematicBody2D")
onready var hp_bar = get_node("HUD/TextureProgress")

func _process(_delta):
	hp_bar.value = player.PLAYER_HEALTH
	if player.PLAYER_HEALTH <= 0:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
