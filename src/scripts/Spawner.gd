extends Node2D

export (PackedScene) var Mob

var spawned = false
var children = []
var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	scene = get_node("..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if $VisibilityNotifier2D.is_on_screen():
		if !spawned:
			spawnMob()
			spawned = true
	else:
		if (children != []):
			#print(nearest_child())
			if nearest_child() > 96 or nearest_child()== -1:
				spawned = false

func nearest_child():
	var nearest = -1
	for child in children:
		if child.get_ref():
			if nearest == -1:
				nearest = position.distance_to(child.get_ref().position)
			if position.distance_to(child.get_ref().position) < nearest:
				nearest = position.distance_to(child.get_ref().position)
	return nearest

func spawnMob():
	print("mob spawned!")
	var mob = Mob.instance()
	mob.position = position
	scene.add_child(mob)
	children.append(weakref(mob))
	
