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
var tree_spawn = null
var victory_house_index = -1
var tree_index = -1

func _create_house(type, index):
	var curr_house = type.instance()
	add_child(curr_house)
	curr_house.position = Vector2(step * index, 656)
	return curr_house

func _replace_house(index, type):
	var house_to_replace = houses[index]
	var new_house_pos = house_to_replace.position
	var new_house = type.instance()
	houses[index] = new_house
	house_to_replace.queue_free()
	add_child(new_house)
	new_house.position = new_house_pos
	return new_house

func _create_victory_house():
	if victory_house_index != -1:
		_replace_house(victory_house_index, house)

	if int(rand_range(0, 2)) == 0:
		victory_house_index = rand_range(0, tree_index + 1 - house_padding)
	else:
		victory_house_index = rand_range(tree_index + house_padding, houses.size())
	
	victory_house_index = int(victory_house_index)
	print("victory_house_index: ", victory_house_index)
	
	var curr_house = _replace_house(victory_house_index, victory_house)
	curr_house.name = "victory_house"
	curr_house.emit_created()
	return curr_house

func _ready():
	randomize()
	var victory_house_exists = false
	
	for i in range(0, house_count + 1):
		houses.append(_create_house(house, i))
	
	tree_index = ceil(house_count / 2) - 1
	var tree_house = houses[tree_index]
	tree_spawn = tree_house.position + Vector2(0, 48 * 2 + 32) # nice
	tree.position = tree_spawn
	tree.spawn_position = Transform2D(0, tree_spawn)
	print("tree spawn: ", tree_spawn)
	tree_house.queue_free()

	var victory_house = _create_victory_house()

func on_game_over(score):
	tree.prepare_launch(tree_spawn)
	_create_victory_house()