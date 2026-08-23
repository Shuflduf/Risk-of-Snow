extends Area3D

@export var bungus_mesh: PackedScene
@onready var heal_timer: Timer = $HealTimer

func _ready() -> void:
	spawn_bungus()
	heal_timer.timeout.connect(_heal)


func _heal() -> void:
	for hurtbox: Hurtbox in get_overlapping_areas():
		var dmg: Hurtbox.DamageEntry = Hurtbox.DamageEntry.new()
		dmg.damage = -5
		dmg.knockback = Vector3.ZERO
		dmg.screen_shake = 0.0
		hurtbox.hit(dmg)

func spawn_bungus() -> void:
	for i: int in 100:
		var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		var bungus: Node3D = bungus_mesh.instantiate()
		var angle: float = randf_range(0, PI * 2.0)
		var distance: float = sqrt(randf()) * 2.0
		bungus.position = Vector3(cos(angle) * distance, -0.15, sin(angle) * distance)
		bungus.scale = Vector3.ZERO
		tween.tween_interval(randf())
		tween.tween_property(bungus, ^"scale", Vector3.ONE * randf_range(0.7, 1.2), 0.5)
		tween.parallel().tween_property(bungus, ^"rotation", Vector3(randf_range(-0.3, 0.3), randf_range(0, PI * 2), randf_range(-0.3, 0.3)), 0.5)
		add_child(bungus)
