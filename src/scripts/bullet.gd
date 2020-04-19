extends Area2D

# apply a velocity
export var velocity = Vector2()

# Called when the node enters the scene tree for the first time.

func _ready():
	set_process(true)
	yield(get_node("VisibilityNotifier2D"), "screen_exited")
	queue_free() # destroy bullet

func _process(delta):
	translate(velocity * delta)



func _on_bullet_area_entered(area):
	queue_free()
