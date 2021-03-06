extends Node

const SERVER_IP = "186.129.105.198"
const SERVER_PORT = 3000
const MAX_PLAYERS = 10
var peer
var my_info = null
var player = preload("res://Game/Actors/Player/Player.tscn")
var player_info = {}
var colors = [
	Color8(0, 255, 255),
	Color8(255, 0, 255),
	Color8(255, 255, 0),
	Color8(0, 0, 255),
	Color8(255, 0, 0),
	Color8(0, 255, 0),
	Color8(0, 100, 0),
	Color8(0, 0, 100),
	Color8(100, 0, 0)
]
var index_color = 0


func _ready():
	Main.lobby = self
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")


func _server():
	print("_server")
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	$ColorRect.hide()
	

func _get_name():
	return $ColorRect/TextEdit.text

func _client():
	print("_client")
	# TextEdit
	print_debug(my_info)
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	$ColorRect.hide()
	


# Info we send to other players


func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	print("_player_connected: ", id)
	if get_tree().is_network_server():
		return

	if my_info == null:
		my_info = { name = _get_name(), color_id = 0 }
#		id from server = 1
		rpc_id(1, "register_player", my_info)


func _player_disconnected(id):
	print("_player_disconnected")
	player_info.erase(id) # Erase player from info.
	remove_child(Main.players[id])

func _connected_ok():
	print_debug("_connected_ok")
	

func _server_disconnected():
	print_debug("_server_disconnected")
	pass # Server kicked us; show error and abort.

func _connected_fail():
	print_debug("_connected_fail")
	pass # Could not even connect to server; abort.

remote func register_player(info):
	# executed on server side
	print_debug("register_player")
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	info.color_id = index_color
	index_color = index_color + 1
	if index_color == 7:
		index_color = 0
	player_info[id] = info
	#show info
	print_debug(player_info)
	$Label.text = $Label.text +"\n$" + str(player_info) 
	#send full list to sender
	rpc("show_list", player_info)

remotesync func show_list(player_info):
	print_debug("show_list ", player_info)
	for id_connection in player_info:
		if !Main.players.has(id_connection):
			var instance = player.instance()
			Main.players[id_connection] = instance
			instance.set_name(str(id_connection))
			add_child(instance)
			instance.position = Vector2(100, 100)
			instance.modulate = colors[player_info[id_connection].color_id]
			$Label.text = $Label.text +"\n$" + str(id_connection) 
