extends ParallaxBackground

signal reboot_signal

var playing = false

func _ready():
	$AnimationPlayer.play("FadeOut")
	$GameoverScreen.visible = false
	$GameendScreen.visible = false

func _process(_delta):
	if $GameoverScreen.visible and Input.is_action_just_pressed("shoot"):
		$AnimationPlayer.play("FadeInRest")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("reboot_signal")
		
	if $GameendScreen.visible and Input.is_action_just_pressed("shoot") and !playing:
		emit_signal("reboot_signal")

func show_gameover():
	$AnimationPlayer.play("FadeIn")
	yield($AnimationPlayer, "animation_finished")
	$GameoverScreen.play()
	$GameoverScreen.visible = true
	yield($GameoverScreen, "animation_finished")
	$GameoverScreen.stop()
	$GameoverScreen.frame = 1

func show_gameend(is_good):
	playing = true
	$GameendScreen.show()
	$GameendScreen.set_speed_scale(0.75)
	if is_good: 
		$GameendScreen.play("GoodEnd")
	else: 
		$GameendScreen.play("BadEnd")
	yield($GameendScreen, "animation_finished")
	playing = false
