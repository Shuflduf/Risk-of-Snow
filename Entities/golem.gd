extends CharacterBody3D

const SPEED: float = 100.0

var player: CharacterBody3D
@onready var anim: AnimationPlayer = $Mesh/AnimationPlayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group(&"Player")
	anim.play(&"Walk")
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if player:
		
		var dir: Vector3 = (player.position - position).normalized()
		rotation.y = lerp_angle(rotation.y,atan2(-dir.x, -dir.z), delta * 5.0  ) 
		velocity.x = dir.x * delta * SPEED
		velocity.z = dir.z * delta * SPEED

	move_and_slide()
