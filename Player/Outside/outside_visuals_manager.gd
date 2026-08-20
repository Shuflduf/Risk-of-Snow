extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = get_parent()


func _ready() -> void:
	anim.play(&"Idle")
	

func _process(delta: float) -> void:
	if player.velocity.length_squared() > 2.0:
		anim.play(&"Run")
		rotation.y = lerp_angle(
			rotation.y,
			atan2(-player.velocity.x, -player.velocity.z),
			delta * 10.0
		)
	else:
		#anim.stop()
		anim.play(&"Idle")
