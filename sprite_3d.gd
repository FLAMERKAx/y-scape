extends Sprite3D

var y = 0.001
var x = 0.001
var z = 0.001

var sprite_name = "SEWERSLVT"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		x += 0.001
		rotate_x(x)
	elif Input.is_action_pressed("ui_down"):
		z += 0.001
		rotate_z(z)
	elif Input.is_action_pressed("ui_right"):
		y += 0.001
		rotate_y(y)
	
