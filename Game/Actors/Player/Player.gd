extends KinematicBody2D

class_name Player

var dir_y = 0
var dir_rotation = 0
var speed = 100
var speed_rotation = 100

func _ready():
	pass


func _process(delta):
	rpc_unreliable("move", delta)


remotesync func move(delta):
	dir_rotation = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	dir_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	var x = speed * sin(-rotation)
	var y = speed * cos(-rotation)

	if dir_y == 1:
#		move_and_slide(Vector2(0, dir_y * 100), position.rotated(rotation))
		move_and_slide(Vector2(x, y))
	elif dir_y == -1:
#		move_and_slide(Vector2(0, dir_y * 100), position.rotated(rotation))
		move_and_slide(Vector2(-x, -y))
	
	print_debug(rotation)
	
	if dir_rotation == 1:
		rotation_degrees += dir_rotation * delta * speed_rotation
	elif dir_rotation == -1:
		rotation_degrees -= dir_rotation * delta * -speed_rotation
		
