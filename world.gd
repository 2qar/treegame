extends Node2D

onready var tree = get_node("tree")

var house = preload("res://house.tscn")
var victory_house = preload("res://victory_house.tscn")

export(int) var house_count = 25
export(int) var house_padding = 3
export(int) var house_seperation = 2
onready var step = 176 * house_seperation

var left_start = 396
var right_start = 576
var houses = []

func _create_house(type, index):
	var curr_house = type.instance()
	add_child(curr_house)
	curr_house.position = Vector2(step * index, 656)
	return curr_house

func _ready():
	randomize()
	var victory_house_exists = false
	
	for i in range(0, house_count + 1):
		houses.append(_create_house(house, i))
	
	var tree_index = ceil(house_count / 2) - 1
	var tree_house = houses[tree_index]
	var tree_spawn = tree_house.position + Vector2(0, -48)
	tree.position = tree_spawn

	var victory_house_index = 0
	if int(rand_range(0, 2)) == 0:
		victory_house_index = rand_range(0, tree_index + 1 - house_padding)
	else:
		victory_house_index = rand_range(tree_index + house_padding, houses.size())
	
	victory_house_index = int(victory_house_index)
	print("victory_house_index: ", victory_house_index)
	var selected_house = houses[victory_house_index]

	var new_house = victory_house.instance()
	var new_house_pos = selected_house.position
	selected_house.queue_free()
	add_child(new_house)
	new_house.position = new_house_pos
	new_house.emit_created()