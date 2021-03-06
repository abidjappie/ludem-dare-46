extends Node2D

onready var player = get_node("Player_KinematicBody2D")
onready var pet = get_node("Pet_Node")
onready var objectives = get_node("Objectives")
onready var hp_bar = get_node("HUD/TextureProgress")
onready var screens = get_node("Screens")

var PLAYER_HEALTH = 10

func _ready():
	pass # init here

func _process(_delta):
	hp_bar.value = PLAYER_HEALTH
	if PLAYER_HEALTH <= 0 and !player.dying:
		# warning-ignore:return_value_discarded
		player.die()
		yield(player, "death_signal")
		screens.show_gameover()
		yield(screens, "reboot_signal") 
		get_tree().reload_current_scene()
	if (objectives.objective_list.size()==0): # all checkpoints reached
		print("All checkpoints reached! PLAYER WINS!")
		screens.show_gameend(PLAYER_HEALTH==10)
		yield(screens, "reboot_signal")
		get_tree().reload_current_scene()
