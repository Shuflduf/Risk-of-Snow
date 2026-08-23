extends Area3D

@export var bungus_mesh: PackedScene
@onready var heal_timer: Timer = $HealTimer
@onready var despawn_timer: Timer = $DespawnTimer
@onready var bungi: Node3D = $Bungi
@onready var particles: GPUParticles3D = $GPUParticles3D


func _ready() -> void:
	spawn_bungus()
	heal_timer.timeout.connect(_heal)
	despawn_timer.timeout.connect(_despawn)


func _heal() -> void:
	for hurtbox: Hurtbox in get_overlapping_areas():
		var dmg: Hurtbox.DamageEntry = Hurtbox.DamageEntry.new()
		dmg.damage = -3
		dmg.knockback = Vector3.ZERO
		dmg.screen_shake = 0.0
		hurtbox.hit(dmg)


func _despawn() -> void:
	particles.emitting = false
	for bungus: Node3D in bungi.get_children():
		var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(
			Tween.TRANS_QUAD
		)
		tween.tween_interval(randf())
		tween.tween_property(bungus, ^"scale", Vector3.ZERO, 0.5)
		tween.parallel().tween_property(bungus, ^"rotation", Vector3.ZERO, 0.5)
		tween.finished.connect(func() -> void: bungus.queue_free())
	await get_tree().create_timer(2.0).timeout
	queue_free()


func spawn_bungus() -> void:
	for i: int in 100:
		var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(
			Tween.TRANS_QUAD
		)
		var bungus: Node3D = bungus_mesh.instantiate()
		var angle: float = randf_range(0, PI * 2.0)
		var distance: float = sqrt(randf()) * 2.0
		bungus.position = Vector3(cos(angle) * distance, -0.15, sin(angle) * distance)
		bungus.scale = Vector3.ZERO
		tween.tween_interval(randf())
		tween.tween_property(bungus, ^"scale", Vector3.ONE * randf_range(0.7, 1.2), 0.5)
		tween.parallel().tween_property(
			bungus,
			^"rotation",
			Vector3(randf_range(-0.3, 0.3), randf_range(0, PI * 2), randf_range(-0.3, 0.3)),
			0.5
		)
		bungi.add_child(bungus)
