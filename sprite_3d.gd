extends Sprite3D

var coins = 5
var sprite_name = "SEWERSLVT"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(0.05)
	rotate_x(0.03)
	rotate_z(0.04)
	
