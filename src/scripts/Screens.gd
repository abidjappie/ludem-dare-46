extends ParallaxBackground

signal reboot_signal

func _ready():
	$AnimationPlayer.play("FadeOut")
	$GameoverScreen.visible = false

func _process(_delta):
	if $GameoverScreen.visible and Input.is_action_just_pressed("shoot"):
		$AnimationPlayer.play("FadeInRest")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("reboot_signal")

func show_gameover():
	$AnimationPlayer.play("FadeIn")
	yield($AnimationPlayer, "animation_finished")
	$GameoverScreen.play()
	$GameoverScreen.visible = true
	yield($GameoverScreen, "animation_finished")
	$GameoverScreen.stop()
	$GameoverScreen.frame = 1
