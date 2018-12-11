extends RigidBody2D

var game_over = false

func _ready():
	var launch_force = 300
	self.apply_impulse(Vector2(), Vector2(0, -launch_force))

func _process(delta):
	pass

func _integrate_forces(state):
	if Input.is_action_pressed("left_click"):
		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - self.position).normalized()
		self.apply_impulse(Vector2(), dir * 25)

func _physics_process(delta):
	if not game_over:
		self.look_at(get_global_mouse_position())
		self.rotate(deg2rad(90))

func on_game_over():
	game_over = true
	self.set_mode(RigidBody2D.MODE_STATIC)
	print("game over. :(")