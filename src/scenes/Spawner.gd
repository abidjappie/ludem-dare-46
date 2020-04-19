extends Node2D

export (PackedScene) var Mob

var spawned = false
var last_child = null
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
		if (last_child!=null):
			if position.distance_to(last_child.position)>10:
				spawned = false

func spawnMob():
	var mob = Mob.instance()
	mob.position = position
	scene.add_child(mob)
	last_child = mob
	
