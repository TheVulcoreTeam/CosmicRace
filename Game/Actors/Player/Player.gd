extends KinematicBody2D

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
		rpc_unreliable("move_ahead", rotation)
	elif dir_y == -1:
#		move_and_slide(Vector2(0, dir_y * 100), position.rotated(rotation))
#		move_and_slide(Vector2(-x, -y))
		rpc_unreliable("move_back", rotation)
	
#	print_debug(rotation)
	
	if dir_rotation == 1:
		rpc_unreliable("_rotate", true)
	elif dir_rotation == -1:
		rpc_unreliable("_rotate", false)

remotesync func move_ahead(rotation):
	var x = speed * sin(-rotation)
	var y = speed * cos(-rotation)
	move_and_slide(Vector2(x, y))


remotesync func move_back(rotation):
	var x = speed * sin(-rotation)
	var y = speed * cos(-rotation)
	move_and_slide(Vector2(-x, -y))


remotesync func _rotate(side):
	var n = -1
	if(side):
		n = 1
	rotation_degrees += 0.016 * speed_rotation * n
