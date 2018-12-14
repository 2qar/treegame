extends Area2D

signal created
signal game_over

export var SPEED_THRESHOLD = 500

func _ready():
	connect("created", get_node("../tree"), "_on_victory_house_created")
	connect("created", get_node("../tree/camera"), "_on_victory_house_created")
	connect("game_over", get_node("../tree"), "on_game_over")

func emit_created():
	emit_signal("created", position)

func _process(delta):
	pass

func speed_too_high(tree_velocity):
	return abs(tree_velocity.x) > SPEED_THRESHOLD or abs(tree_velocity.y) > SPEED_THRESHOLD

func _on_victory_house_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == 'tree':
		if speed_too_high(body.linear_velocity):
			emit_signal("game_over")
			self.queue_free()
