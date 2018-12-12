extends Camera2D

var near_house = false
onready var house_pos = get_node("../../victory_house").position

func _process(delta):
	#focus_on_house()
	pass

func focus_on_house():
	if near_house:
		#house_focus = $house_focus
		var tree_pos = get_node("../../tree").position
		var distance = tree_pos.distance_to(house_pos)
		var zoom = distance / 1000
		self.zoom = Vector2(zoom, zoom)
		
		#house_focus.interpolate_property(self, "zoom", self.zoom, 
	elif self.zoom != Vector2(1, 1):
		self.zoom = Vector2(1, 1)

func on_near_house(is_near):
	near_house = is_near