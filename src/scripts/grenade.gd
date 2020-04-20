extends Area2D

var from_who
var direction
var target = Vector2()
var velocity = Vector2()

const v = 150
const GRAVITY = 120

func _ready():
	var x = abs(target.x-position.x)
	var y = abs(target.y-position.y)
	var calc1 = ((v*v)-sqrt((v*v*v*v)-GRAVITY*((GRAVITY*x*x)+(2*y*v*v))))/(GRAVITY*x)
	var calc2 = ((v*v)+sqrt((v*v*v*v)-GRAVITY*((GRAVITY*x*x)+(2*y*v*v))))/(GRAVITY*x)
	var angle
	
	print("Calc1")
	print(calc1)
	print("Calc2")
	print(calc2)
	
	if calc2< 4.6:
		angle =atan(calc2)
	else:
		angle =atan(4.6)
		
	print(angle)
	
	velocity.x = direction*v*cos(angle)
	velocity.y = -v*sin(angle)
	
	set_process(true)
	#yield(get_node("VisibilityNotifier2D"), "screen_exited")
	#queue_free() # destroy bullet

func _physics_process(delta):
	translate(velocity * delta)
	velocity.y = velocity.y + GRAVITY*delta

func _on_bullet_area_entered(area):
	if (area.get_parent().get_name() != from_who) and (area.get_name() != from_who) and (area.get_name() !="grenade"):
		queue_free()

