extends Area2D

# apply a velocity
export var velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	yield(get_node("VisibilityNotifier2D"), "exit_screen")
	queue_free() # destroy bullet
	pass # Replace with function body.

func _process(delta):
	translate(velocity * delta)
