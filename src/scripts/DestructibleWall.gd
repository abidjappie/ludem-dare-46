extends StaticBody2D

var health

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 4

func _process(delta):
	if (health < 1):
		$AnimatedSprite.play("Explode")
		yield($AnimatedSprite, "animation_finished")
		queue_free()

func _on_Area2D_area_entered(area):
	if (area.get_name()=='bullet'):
		health -=1 
		if area.velocity.x > 0:
			if $AnimatedSprite.animation == "Idle":
				$AnimatedSprite.play("HitLeft")
				$AnimatedSprite.speed_scale = 3;
				yield($AnimatedSprite, "animation_finished")
				$AnimatedSprite.play("Idle")
		else:
			if $AnimatedSprite.animation == "Idle":
				$AnimatedSprite.play("HitRight")
				$AnimatedSprite.speed_scale = 3;
				yield($AnimatedSprite, "animation_finished")
				$AnimatedSprite.play("Idle")
