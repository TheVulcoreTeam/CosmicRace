extends Node

const SERVER_IP = "186.129.67.167"
const SERVER_PORT = 3000
const MAX_PLAYERS = 10
var peer
var my_info

func _ready():
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
	

func _get_name():
	return $TextEdit.text

func _client():
	print("_client")
	my_info = { name = _get_name(), favorite_color = Color8(255, 0, 255) }#TextEdit
	print_debug(my_info)
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	

# Player info, associate ID to data
var player_info = {}
# Info we send to other players


func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	print("_player_connected ")
	if get_tree().is_network_server():
		return
	rpc_id(id, "register_player", my_info)

func _player_disconnected(id):
	print("_player_disconnected")
	player_info.erase(id) # Erase player from info.

func _connected_ok():
	print("_connected_ok")
	

func _server_disconnected():
	print("_server_disconnected")
	pass # Server kicked us; show error and abort.

func _connected_fail():
	print("_connected_fail")
	pass # Could not even connect to server; abort.

remote func register_player(info):
	# executed on server side
	print("register_player")
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info
	#show info
	print(player_info)
	$ColorRect/Label.text = $ColorRect/Label.text +"\n$" + str(player_info) + "\n$"
	#send full list to sender
	rpc_id(id, "show_list", player_info)

remote func show_list(player_info):
	print("show_list ", player_info)
	$ColorRect/Label.text = $ColorRect/Label.text +"\n$" + str(player_info) + "\n$"
