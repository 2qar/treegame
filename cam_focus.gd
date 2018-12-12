extends Area2D

signal near_house

func _ready():
	connect("near_house", get_node('../../tree/camera'), "on_near_house")
	connect("near_house", get_node('../../tree'), "on_near_house")
	pass


func _on_cam_focus_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == 'tree':
		emit_signal("near_house", true)


func _on_cam_focus_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.name == 'tree':
		emit_signal("near_house", false)