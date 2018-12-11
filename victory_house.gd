extends Area2D

signal game_over

func _ready():
	connect("game_over", get_node("../tree"), "on_game_over")

func _process(delta):
	pass

func _on_victory_house_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == 'tree':
		emit_signal("game_over")
		self.queue_free()
