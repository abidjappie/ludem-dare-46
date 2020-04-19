extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../Player_KinematicBody2D/Pivot/CameraOffset/Camera2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# X movement 16 pixels
	# Y movement 30 pixels
	$background.offset.x = 8-round(camera.get_camera_screen_center().x/96) 
	$background.offset.y = round(camera.get_camera_screen_center().y/27.2)
	$background.offset.x = clamp($background.offset.x, -8, 8)
	$background.offset.y = clamp($background.offset.y, 0, 30)
	
	$background_frontlayer2.offset.y = -round(camera.get_camera_screen_center().y/18)
	$background_frontlayer2.offset.y = clamp($background_frontlayer2.offset.y, -45, 0)
