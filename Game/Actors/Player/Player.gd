extends Node2D

class_name Player

var dir_y = 0
var dir_rotation = 0
var speed = 100
var speed_rotation = 100

func _ready():
	pass


func _process(delta):
	move(delta)


func move(delta):
	dir_rotation = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	dir_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
#	var x = speed * sin(-rotation)
#	var y = speed * cos(-rotation)

	if dir_y == 1:
#		move_and_slide(Vector2(0, dir_y * 100), position.rotated(rotation))
#		move_and_slide(Vector2(x, y))
		rpc_unreliable("move_ahead", delta)
	elif dir_y == -1:
#		move_and_slide(Vector2(0, dir_y * 100), position.rotated(rotation))
#		move_and_slide(Vector2(-x, -y))
		rpc_unreliable("move_back", delta)
	
#	print_debug(rotation)
	
	if dir_rotation == 1:
		rpc_unreliable("rotate_left", delta)
	elif dir_rotation == -1:
		rpc_unreliable("rotate_right", delta)

remotesync func move_ahead(delta):
	global_position.y += 100 * delta


remotesync func move_back(delta):
	global_position.y -= 100 * delta


remotesync func rotate_left(delta):
	rotation_degrees += dir_rotation * delta * speed_rotation


remotesync func rotate_right(delta):
	rotation_degrees -= dir_rotation * delta * -speed_rotation

