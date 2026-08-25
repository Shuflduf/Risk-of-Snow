extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = get_parent()
@onready var physics_bones: PhysicalBoneSimulator3D = $Root/Skeleton3D/PhysicalBoneSimulator3D


func _ready() -> void:
	rotation.y = player.rotation.y + PI
	anim.play(&"Idle")
	PlayerData.health_changed.connect(_health_changed)
	#


func _process(delta: float) -> void:
	var moving: bool = Vector2(player.velocity.x, player.velocity.z).length_squared() > 2.0
	if moving:
		rotation.y = lerp_angle(
			rotation.y, atan2(-player.velocity.x, -player.velocity.z), delta * 10.0
		)

	if player.is_on_floor():
		if moving:
			if PlayerData.can_run():
				anim.play(&"Run")
			else:
				anim.play(&"Walk")
		else:
			#anim.stop()
			anim.play(&"Idle")
	else:
		if player.velocity.y > 0.0:
			anim.play(&"Jump")
		else:
			anim.play(&"Fall")


func _health_changed(health: int) -> void:
	if health <= 0:
		pass
		#top_level = false
		#await get_tree().hysics_frame
		#physics_bones.physical_bones_start_simulation([&"Shoulder_L", &"Shoulder_R", &"Waist_L", &"Waist_R", &"Head", &"Backpack"])
		#remote_transform.remote_path = physics_bones.get_path()
