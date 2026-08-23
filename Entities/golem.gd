extends CharacterBody3D

const LOOK_MARGIN: float = 1.0
const SPEED: float = 100.0

var player: CharacterBody3D
@onready var anim: AnimationPlayer = $Mesh/AnimationPlayer
@onready var head: MeshInstance3D = $Mesh/Armature/Skeleton3D/Head/Cube
@onready var max_x_rotation: float = PI / 2.0 - LOOK_MARGIN

func _ready() -> void:
	player = get_tree().get_first_node_in_group(&"Player")
	anim.play(&"Walk")
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if player:
		var actual_rot: Vector3 = head.rotation
		var dir: Vector3 = (player.position - position).normalized()
		head.look_at(player.position)
		head.rotation.y = lerp_angle(actual_rot.y, head.rotation.y, delta * 2.0)
		head.rotation.x = clamp(head.rotation.x, -max_x_rotation, max_x_rotation)
		rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), delta * 1.0  ) 
		velocity.x = dir.x * delta * SPEED
		velocity.z = dir.z * delta * SPEED

	move_and_slide()
