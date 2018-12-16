extends RigidBody2D

onready var fuel_label = $fuel
onready var ui = get_node("../ui")
onready var flame = get_node("sprite/rocket/flame")

const MAX_SPEED = 1500

var game_start = true
var game_over = false
var near_house = false
var house_position = Vector2()

export var fly_seconds = 10

var fuel = 60 * fly_seconds
func set_fuel(given_fuel):
	if fuel != given_fuel:
		fuel = given_fuel
		if fuel == 0:
			game_over = true
			$out_of_fuel_wait.start()
			ui.show_no_fuel(true)

var starting_fuel = fuel

var score = 0
var launched = false
var started_launch = false
var reset = false
var spawn_position = null

signal game_over

func _ready():
	connect("game_over", self, "on_game_over")
	connect("game_over", get_node("../../world"), "on_game_over")

func prepare_launch(spawn_pos):
	launched = false
	started_launch = false
	reset = true
	fuel = starting_fuel
	set_mode(RigidBody2D.MODE_RIGID)
	game_over = false
	
func _process(delta):
	ui.set_fuel(fuel)
	if not game_start:
		ui.show_direction(position, house_position)

### SPEED CAP ###
func get_capped_speed(speed):
	if speed < 0:
		return max(speed, -MAX_SPEED)
	else:
		return min(speed, MAX_SPEED)

func cap_speed():
	var velocity = self.linear_velocity
	
	self.linear_velocity.x = get_capped_speed(velocity.x)
	self.linear_velocity.y = get_capped_speed(velocity.y)
###/SPEED CAP/###

func move_to_mouse(speed):
	flame.visible = true
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - self.position).normalized()
	self.apply_impulse(Vector2(), dir * speed)
	set_fuel(fuel - 1)

func _integrate_forces(state):
	fuel_label.text = "fuel: %.f" % ((float(fuel) / starting_fuel) * 100)
	
	if reset:
		state.transform = spawn_position
		state.angular_velocity = 0
		state.linear_velocity = Vector2()
		apply_impulse(Vector2(), -applied_force)
		reset = false
		game_over = false
	
	linear_velocity.y += 8
	
	if not started_launch and not launched:
		$sprite.rotation = 0
		$sprite.rotation_degrees = 0
		linear_velocity = Vector2()
		if Input.is_action_just_pressed("left_click"):
			if game_start:
				ui.show_ui()
				game_start = false
			started_launch = true
			linear_velocity.y = -600
			$launch_wait.start()
	
	cap_speed()
	
	flame.visible = false
	if Input.is_action_pressed("left_click") and fuel > 0 and launched:
		move_to_mouse(25)

func _physics_process(delta):
	if not game_over and launched:
		var mouse_pos = get_global_mouse_position()
		$sprite.look_at(mouse_pos)
		self.rotate(deg2rad(90))

func on_game_over(gained_score):
	game_over = true
	score += gained_score
	ui.set_score(score)

# FIXME: make this work because having the camera kinda follow the mouse is a really nice effect
func aim_cam():
	var target = null
	if near_house:
		target = house_position
	else:
		target = get_global_mouse_position()
	
	var dir = (target - position) / 5
	print(dir)
	$camera.position = Vector2(0, 0)
	$camera.position = dir

func on_near_house(is_near):
	near_house = is_near

func connect_tree_stand_touched(target_node):
	connect("tree_stand_touched", target_node, "_on_tree_stand_touched")

func _on_victory_house_created(victory_house_position):
	house_position = victory_house_position
	#var victory_house = get_node("../victory_house")
	#if not is_connected("tree_stand_touched", victory_house, "_on_tree_stand_touched"):
		#connect_tree_stand_touched(victory_house)
	#else:
	#	disconnect("tree_stand_touched", victory_house, "_on_tree_stand_touched")
	#	connect_tree_stand_touched(victory_house)

func _on_launch_wait_timeout():
	launched = true

func _on_bottom_area_entered(area):
	if area.name == 'tree_stand':
		emit_signal("game_over", 1)

func _on_out_of_fuel_wait_timeout():
	ui.show_no_fuel(false)
	score = 0
	emit_signal("game_over", 0)
