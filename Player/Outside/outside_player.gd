extends CharacterBody3D

const RUN_SPEED: float = 5.0
const WALK_SPEED: float = 2.0
const JUMP_VELOCITY: float = 3.5
const ACCELERATION: float = 10.0
const AIR_ACCELERATION: float = 2.0

var dead: bool = false

@onready var cam_system: Node3D = $CamSystem
@onready var ui: UI = $UI

func _ready() -> void:
	PlayerData.health_changed.connect(_health_changed)


func _physics_process(delta: float) -> void:
	#Dp.push(&"fps", Engine.get_frames_per_second())
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var effective_accel: float = ACCELERATION if is_on_floor() else AIR_ACCELERATION
	
	if dead:
		velocity.x = lerp(velocity.x, 0.0, effective_accel * delta)
		velocity.z = lerp(velocity.z, 0.0, effective_accel * delta)
		move_and_slide()
		if Input.is_action_just_pressed(&"jump"):
			get_tree().quit()
		return
		
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#velocity.x = 0.0
		#velocity.z = 0.0

	var input_dir: Vector2 = Input.get_vector(&"left", &"right", &"forward", &"backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var speed: float = RUN_SPEED if PlayerData.can_run() else WALK_SPEED
	velocity.x = lerp(velocity.x, direction.x * speed, effective_accel * delta)
	velocity.z = lerp(velocity.z, direction.z * speed, effective_accel * delta)

	move_and_slide()


func _health_changed(health: int) -> void:
	if health <= 0:
		dead = true
		ui.die()

func set_cam_rotation(new_rot: Vector3) -> void:
	cam_system.set_cam_rotation(new_rot)
