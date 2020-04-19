extends Node2D

export (PackedScene) var Mob

var spawned = false
var children = []
var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	scene = get_node("..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $VisibilityNotifier2D.is_on_screen():
		if !spawned:
			spawnMob()
			spawned = true
	else:
		if (children!=[]):
			if nearest_child()>96:
				spawned = false

func nearest_child():
	var nearest = position.distance_to(children[0].position)
	for child in children:
		if position.distance_to(child.position) < nearest:
			nearest = position.distance_to(child.position)
	return nearest

func spawnMob():
	var mob = Mob.instance()
	mob.position = position
	scene.add_child(mob)
	children.append(mob)
	
