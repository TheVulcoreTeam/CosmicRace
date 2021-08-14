extends KinematicBody2D

var dir_y = 0
var dir_rotation = 0
var speed = 100
var speed_rotation = 100

func _ready():
	Main.id_connection = get_tree().get_network_unique_id()


func _process(delta):
	_rotate_loca(delta)
	_move_local()
	
	if str(Main.id_connection) ==  name:
		input_sender(delta)


func _rotate_loca(delta):
	if dir_rotation != 0:
		rotation_degrees += delta * speed_rotation * dir_rotation


func _move_local():
	if dir_y != 0:
		var x = speed * sin(-rotation)
		var y = speed * cos(-rotation)
		if dir_y == 1:
			move_and_slide(Vector2(x, y))
		elif dir_y == -1:
			move_and_slide(Vector2(-x, -y))


func input_sender(delta):
	if Input.is_action_just_pressed("ui_right"):
		rpc_unreliable("_rotate", [1, rotation])
	if Input.is_action_just_pressed("ui_left"):
		rpc_unreliable("_rotate", [-1, rotation])

	if Input.is_action_just_released("ui_right"):
		if Input.is_action_pressed("ui_left"):
			rpc_unreliable("_rotate", [-1, rotation])
		else:
			rpc_unreliable("_rotate", [0, rotation])
	if Input.is_action_just_released("ui_left"):
		if Input.is_action_pressed("ui_right"):
			rpc_unreliable("_rotate", [1, rotation])
		else:
			rpc_unreliable("_rotate", [0, rotation])


	if Input.is_action_just_pressed("ui_down"):
		rpc_unreliable("move_ahead", [1, rotation, position])
	if Input.is_action_just_pressed("ui_up"):
		rpc_unreliable("move_ahead", [-1, rotation, position])
		
	if Input.is_action_just_released("ui_down"):
		if Input.is_action_pressed("ui_up"):
			rpc_unreliable("move_ahead", [-1, rotation, position])
		else:
			rpc_unreliable("move_ahead", [0, rotation, position])
	if Input.is_action_just_released("ui_up"):
		if Input.is_action_pressed("ui_down"):
			rpc_unreliable("move_ahead", [1, rotation, position])
		else:
			rpc_unreliable("move_ahead", [0, rotation, position])


remotesync func _rotate(data):
	var id = get_tree().get_rpc_sender_id()
	if Main.players.has(id):
		Main.players[id].dir_rotation = data[0]
		Main.players[id].rotation = data[1]

#remote input
remotesync func move_ahead(data):
	var id = get_tree().get_rpc_sender_id()
	if Main.players.has(id):
		Main.players[id].dir_y = data[0]
		Main.players[id].rotation = data[1]
		Main.players[id].position = data[2]




