class_name SnowChunk
extends MeshInstance3D

const CHUNK_SIZE: float = 32.0

@export var indent_tex: GradientTexture2D
@export var indent_size: int = 6
@export var pos: Vector2i

@onready var m: PlaneMesh = mesh
@onready var entity_detector: Area3D = $EntityDetector
var depth_tex: DrawableTexture2D


func _ready() -> void:
	if SnowServer.chunks.has(pos):
		depth_tex = SnowServer.chunks[pos]
	else:
		depth_tex = DrawableTexture2D.new()
		depth_tex.setup(64, 64, DrawableTexture2D.DRAWABLE_FORMAT_RGBA8, Color.WHITE)
		SnowServer.chunks.set(pos, depth_tex)
	m.material.set_shader_parameter(&"snow_depth_texture", depth_tex)
	entity_detector.body_entered.connect(_on_body_entered)
	SnowServer.update_snow.connect(_update_snow)


func _on_body_entered(body: Node3D) -> void:
	SnowServer.entered_chunk(pos)
	SnowServer.tracked_bodies.set(body, body.position)


func _update_snow(body: Node3D) -> void:
	if not body in entity_detector.get_overlapping_bodies():
		return

	var rel_pos: Vector3 = body.position - position  # -16 - 16
	rel_pos += Vector3(16.0, 0.0, 16.0)  # 0 - 32
	rel_pos *= 2  # 0 - 64
	depth_tex.blit_rect(
		Rect2i(int(rel_pos.x - indent_size / 2.0), int(rel_pos.z - indent_size / 2.0), indent_size, indent_size),
		indent_tex
	)
	SnowServer.tmp_image.texture = depth_tex
