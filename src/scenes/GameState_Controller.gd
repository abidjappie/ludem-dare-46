extends Node2D

onready var player = get_node("Player_KinematicBody2D")
onready var objectives = get_node("Objectives")
onready var hp_bar = get_node("HUD/TextureProgress")
onready var screens = get_node("Screens")

func _process(_delta):
	hp_bar.value = player.PLAYER_HEALTH
	if player.PLAYER_HEALTH <= 0 and !player.dying:
		# warning-ignore:return_value_discarded
		player.die()
		yield(player, "death_signal")
		screens.show_gameover()
		yield(screens, "reboot_signal") 
		get_tree().reload_current_scene()
	if (objectives.objective_list.size()==0): # all checkpoints reached
		print("All checkpoints reached! PLAYER WINS!")
		get_tree().quit() # exit game

