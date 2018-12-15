extends StaticBody2D

func _ready():
	add_snow()

func _get_snow_num():
	return int(round(rand_range(1, 3)))

func add_snow():
	var snow_count = _get_snow_num()
	var used_snow = []
	for i in range(snow_count):
		var snow_num = _get_snow_num()
		while snow_num in used_snow:
			snow_num = _get_snow_num()

		used_snow.append(snow_num)
		var snow_path = "res://snow_%d.png" % snow_num
		var snow_img = load(snow_path)
		
		var snow = Sprite.new()
		add_child(snow)
		snow.scale = $sprite.scale
		snow.position = Vector2(0, -35)
		snow.texture = snow_img
	#print(name, used_snow)