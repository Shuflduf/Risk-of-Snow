extends Control

@export_file("*.tscn") var starting_scene: String

@onready var subviewport_container: SubViewportContainer = $SubViewportContainer
@onready var particles: GPUParticles2D = %GPUParticles2D
@onready var secondary_particles: GPUParticles2D = %GPUParticles2D2


func _process(_delta: float) -> void:
	particles.position.x = subviewport_container.size.x / 2.0
	(particles.process_material as ParticleProcessMaterial).emission_box_extents.x = subviewport_container.size.x
	
	secondary_particles.position.x = particles.position.x
	(secondary_particles.process_material as ParticleProcessMaterial).emission_box_extents.x = subviewport_container.size.x


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		TransitionHandler.bypass_save_events()
		TransitionHandler.switch_to_scene(self, starting_scene, &"enter_room")
