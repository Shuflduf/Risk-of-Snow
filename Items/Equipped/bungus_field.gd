extends Area3D

@export var bungus_mesh: PackedScene

func _ready() -> void:
	spawn_bungus()
	

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
