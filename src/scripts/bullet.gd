extends Area2D

# apply a velocity
export var velocity = Vector2()
var from_who

# Called when the node enters the scene tree for the first time.

func _ready():
	set_process(true)
	yield(get_node("VisibilityNotifier2D"), "screen_exited")
	queue_free() # destroy bullet

func _process(delta):
	translate(velocity * delta)


func _on_bullet_area_entered(area):
	if (area.get_parent().get_name() != from_who) and (area.get_name() != from_who):
		queue_free()
