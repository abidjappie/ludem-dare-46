extends Area2D

onready var root = get_node("../../")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Node2D_area_entered(area):
	if area.get_name() == "Pet_Node":
		$AnimatedSprite.play("Upgrade")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("Shutdown")
		yield($AnimatedSprite, "animation_finished")
		get_parent().objective_list.erase(self)
		$AnimatedSprite.play("ShutdownIdle")
		root.PLAYER_HEALTH += 5
		if root.PLAYER_HEALTH > 10:
			root.PLAYER_HEALTH = 10 # clamp at max hp
