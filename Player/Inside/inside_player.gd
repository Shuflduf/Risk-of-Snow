extends CharacterBody3D

const SPEED: float = 3.0
const ACCELERATION: float = 8.0

@export var hurtbox: Hurtbox

@onready var cam_system: Node3D = $CamSystem
@onready var passive_heal_timer: Timer = $PassiveHealTimer


func _ready() -> void:
	passive_heal_timer.timeout.connect(_passive_heal)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir: Vector2 = Input.get_vector(&"left", &"right", &"forward", &"backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = lerp(velocity.x, direction.x * SPEED, ACCELERATION * delta)
	velocity.z = lerp(velocity.z, direction.z * SPEED, ACCELERATION * delta)

	move_and_slide()


func _passive_heal() -> void:
	var dmg: Hurtbox.DamageEntry = Hurtbox.DamageEntry.new()
	dmg.damage = -1
	hurtbox.hit(dmg)


func set_cam_rotation(new_rot: Vector3) -> void:
	cam_system.set_cam_rotation(new_rot)
