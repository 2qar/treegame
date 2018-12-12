extends RigidBody2D

var max_speed = 1500

var game_over = false
var near_house = false
onready var house_position = get_node('../victory_house').position

func _ready():
	var launch_force = 300
	self.apply_impulse(Vector2(), Vector2(0, -launch_force))

func _process(delta):
	pass

### SPEED CAP ###
func get_capped_speed(speed):
	if speed < 0:
		return max(speed, -max_speed)
	else:
		return min(speed, max_speed)

func cap_speed():
	var velocity = self.linear_velocity
	
	self.linear_velocity.x = get_capped_speed(velocity.x)
	self.linear_velocity.y = get_capped_speed(velocity.y)
###/SPEED CAP/###

func move_to_mouse(speed):
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - self.position).normalized()
	self.apply_impulse(Vector2(), dir * speed)

func _integrate_forces(state):
	cap_speed()
	if Input.is_action_pressed("left_click"):
		move_to_mouse(25)

func _physics_process(delta):
	if not game_over:
		self.look_at(get_global_mouse_position())
		self.rotate(deg2rad(90))

func on_game_over():
	game_over = true
	self.set_mode(RigidBody2D.MODE_STATIC)
	print("game over. :(")

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

func _on_bottom_area_entered(area):
	if area.name == 'tree_landing_zone':
		on_game_over()