extends CanvasModulate

func _ready():
	pass # Replace with function body.
	
func hit():
	$AnimationPlayer.play("flash")
