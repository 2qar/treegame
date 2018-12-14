extends Node2D

var house = preload("res://house.tscn")
var victory_house = preload("res://victory_house.tscn")

var left_start = 396
var right_start = 576
const STEP = 176 * 2

func _create_house(start, type, index, extra_start=0):
	var curr_house = type.instance()
	add_child(curr_house)
	curr_house.position = Vector2(start + extra_start + STEP * index, 656)
	return curr_house

func _ready():
	randomize()
	var victory_house_exists = false
	var houses = []
	
	# create some filler houses
	for i in range(0, 5):
		_create_house(right_start, house, i)
	
	# randomly place the chosen house
	for i in range(0, 5):
		var curr_house = null
		# FIXME: v
		var rand_num = rand_range(0, 6)
		if rand_num < 4 or victory_house_exists:
			curr_house = house
		else:
			curr_house = victory_house
			victory_house_exists = true

		houses.append(_create_house(right_start, curr_house, i + 5))
		if curr_house == victory_house:
			houses[i].emit_created()

	if not victory_house_exists:
		var victory_house_index = rand_range(0, houses.size())
		var selected_house = houses[victory_house_index]

		var new_house = victory_house.instance()
		var new_house_pos = selected_house.position
		selected_house.queue_free()
		add_child(new_house)
		new_house.position = new_house_pos
		new_house.emit_created()