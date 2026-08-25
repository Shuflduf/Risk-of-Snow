extends CharacterBody3D

const LOOK_MARGIN: float = 1.0
const SPEED: float = 100.0
const STOMP_HIT_FRAME: int = 27
const FPS: int = 24

var attacking: bool = false
var player: CharacterBody3D
var id: int = ResourceUID.create_id()

@onready var anim: AnimationPlayer = $Mesh/AnimationPlayer
@onready var head: MeshInstance3D = $Mesh/Armature/Skeleton3D/Head/Cube
@onready var max_x_rotation: float = PI / 2.0 - LOOK_MARGIN
@onready var hitbox: Area3D = %Hitbox
@onready var stomp_particles: GPUParticles3D = %StompParticles


func _ready() -> void:
	player = get_tree().get_first_node_in_group(&"Player")
	anim.play(&"Walk")
	anim.animation_finished.connect(_on_anim_finished)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if player:
		var actual_rot: Vector3 = head.rotation
		var dir: Vector3 = (player.position - position).normalized()
		if position.distance_squared_to(player.position) < 20.0 and not attacking:
			anim.play(&"Stomp")
			attacking = true
			velocity.x = 0.0
			velocity.z = 0.0
			get_tree().create_timer(float(STOMP_HIT_FRAME) / float(FPS)).timeout.connect(_stomp)
		if not attacking:
			head.look_at(player.position)
			head.rotation.y = lerp_angle(actual_rot.y, head.rotation.y, delta * 2.0)
			head.rotation.x = clamp(head.rotation.x, -max_x_rotation, max_x_rotation)
			rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), delta * 1.0)
			velocity.x = dir.x * delta * SPEED
			velocity.z = dir.z * delta * SPEED

	move_and_slide()


func _on_anim_finished(anim_name: StringName) -> void:
	match anim_name:
		&"Stomp":
			anim.play(&"Walk")
			attacking = false


func _stomp() -> void:
	stomp_particles.restart()
	for hurtbox: Hurtbox in hitbox.get_overlapping_areas():
		var dmg: Hurtbox.DamageEntry = Hurtbox.DamageEntry.new()
		dmg.damage = 40
		dmg.knockback = (
			(hurtbox.global_position - global_position + Vector3(0.0, 4.0, 0.0)).normalized() * 20.0
		)
		dmg.screen_shake = 1.0
		print(dmg.knockback.length())
		hurtbox.hit(dmg)


func entity_data() -> EntityData:
	var data: EntityData = EntityData.new()
	data.position = position
	data.rotation = rotation
	data.scene = load(scene_file_path)
	return data
