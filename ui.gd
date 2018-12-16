extends CanvasLayer

var fuel = 0

func _ready():
	$left.visible = false
	$right.visible = false

func show_ui():
	$score.visible = true
	$fuel.visible = true
	
	$title.visible = false
	$help.visible = false

func set_score(score):
	var text = "Score: %d" % score
	$score.text = text

func set_fuel(given_fuel):
	if fuel != given_fuel:
		fuel = given_fuel
		var text = "Fuel: %d" % fuel
		$fuel.text = text

func show_no_fuel(show):
	$no_fuel.visible = show

func show_direction(tree_pos, house_pos):
	if abs(tree_pos.x - house_pos.x) <= 500:
		$left.visible = false
		$right.visible = false
	elif tree_pos.x > house_pos.x:
		$left.visible = true
		$right.visible = false
	else:
		$left.visible = false
		$right.visible = true