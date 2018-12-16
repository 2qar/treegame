extends "res://house.gd"

signal created
signal game_over

export var SPEED_THRESHOLD = 500

func connect_nodes(signal_name, node_paths, func_name):
	for node_path in node_paths:
		var node = get_node(node_path)
		connect(signal_name, node, func_name)

func _ready():
	add_snow()
	
	connect_nodes("created", ["../tree", "../tree/camera"], "_on_victory_house_created")
	connect_nodes("game_over", ["../tree", "../../world"], "on_game_over")
	
func emit_created():
	emit_signal("created", position)
	
func speed_too_high(tree_velocity):
	return abs(tree_velocity.x) > SPEED_THRESHOLD or abs(tree_velocity.y) > SPEED_THRESHOLD

func _on_victory_house_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == 'tree':
		if speed_too_high(body.linear_velocity):
			emit_signal("game_over", 0)
			self.queue_free()