extends Node2D

onready var player = get_node("Player_KinematicBody2D")

func _process(_delta):
	if player.PLAYER_HEALTH <= 0:
		get_tree().reload_current_scene()
