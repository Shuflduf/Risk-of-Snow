class_name Hurtbox
extends Area3D

@export var is_player: bool = false
@export var cam_system: CamSystem

@onready var body: CharacterBody3D = get_parent()

class DamageEntry:
	var damage: int
	var knockback: Vector3

func hit(dmg: DamageEntry) -> void:
	if is_player:
		PlayerData.health -= dmg.damage
		body.velocity += dmg.knockback
		cam_system.add_trauma(1.0)
