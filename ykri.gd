extends CharacterBody3D

enum {IDLE, WALK, RUN, JUMP}
var curAnim = IDLE

@onready var armature = $Armature
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var animation_tree: AnimationTree = $AnimationTree


@export var blend_speed = 15

var walk_val = 0
var run_val = 0
var jump_val = 0
var speed = 5.0

const RUN_SPEED = 2
const JUMP_VELOCITY = 6.0
const LERP_VAL = 0.15

func handle_animations(delta):
	match curAnim:
		IDLE:
			walk_val = lerpf(walk_val, 0, blend_speed * delta)
			run_val = lerpf(run_val, 0, blend_speed * delta)
			jump_val = lerpf(jump_val, 0, blend_speed * delta)
		WALK:
			walk_val = lerpf(walk_val, 1, blend_speed * delta)
			run_val = lerpf(run_val, 0, blend_speed * delta)
			jump_val = lerpf(jump_val, 0, blend_speed * delta)
		RUN:
			walk_val = lerpf(walk_val, 0, blend_speed * delta)
			run_val = lerpf(run_val, 1, blend_speed * delta)
			jump_val = lerpf(jump_val, 0, blend_speed * delta)
		JUMP:
			walk_val = lerpf(walk_val, 0, blend_speed * delta)
			run_val = lerpf(run_val, 0, blend_speed * delta)
			jump_val = lerpf(jump_val, 1, blend_speed * delta)

func update_tree():
	animation_tree["parameters/walk/blend_amount"] = walk_val
	animation_tree["parameters/run/blend_amount"] = run_val
	animation_tree["parameters/jump/blend_amount"] = jump_val

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
		spring_arm.rotate_x(-event.relative.y * 0.005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func _physics_process(delta: float):
	handle_animations(delta)
	update_tree()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2
		curAnim = JUMP

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = lerp(velocity.x, direction.x * speed * RUN_SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, direction.z * speed * RUN_SPEED, LERP_VAL)
			if is_on_floor():
				curAnim = RUN
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, LERP_VAL)
			velocity.z = lerp(velocity.z, direction.z * speed, LERP_VAL)
			if is_on_floor():
				curAnim = WALK
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		if Input.is_action_pressed("run"):
			velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
			velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
			if is_on_floor():
				curAnim = IDLE
		else:
			velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
			velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
			if is_on_floor():
				curAnim = IDLE

	move_and_slide()
