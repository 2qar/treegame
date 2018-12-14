extends Camera2D

var near_house = false
var house_pos = Vector2()

func _process(delta):
	#focus_on_house()
	pass

func focus_on_house():
	if near_house:
		var house_focus = $house_focus
		var tree_pos = get_node("../../tree").position
		var distance = tree_pos.distance_to(house_pos)
		var zoom = distance / 1000
		self.zoom = Vector2(zoom, zoom)
		
		#house_focus.interpolate_property(self, "zoom", self.zoom, 
	elif self.zoom != Vector2(1, 1):
		self.zoom = Vector2(1, 1)

func on_near_house(is_near):
	near_house = is_near

func _on_victory_house_created(victory_house_position):
	house_pos = victory_house_position