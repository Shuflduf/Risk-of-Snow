class_name SnowChunk
extends MeshInstance3D

const CHUNK_SIZE: float = 32.0
const TEX_SIZE: int = 65

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
		depth_tex.setup(TEX_SIZE, TEX_SIZE, DrawableTexture2D.DRAWABLE_FORMAT_RGBA8, Color.WHITE)
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
	
	var owner_chunk: Vector2i = Vector2i(
		((Vector2(body.position.x, body.position.z) + Vector2.ONE * 16.0) / 32.0).floor()
	)
	if pos != owner_chunk:
		return

	var rel_pos: Vector2 = (
		Vector2(body.position.x, body.position.z) - Vector2(position.x, position.z)
	)
	for x: int in range(-1, 2):
		for y: int in range(-1, 2):
			var tex: DrawableTexture2D = SnowServer.chunks.get(pos + Vector2i(x, y))
			if tex == null:
				continue
			
			var center: Vector2 = (rel_pos - Vector2(x, y) * 32.0 + Vector2(16.25, 16.25)) * 2.0
			var rect: Rect2i = Rect2i(
				Vector2i((center - Vector2.ONE * (indent_size / 2.0)).floor()),
				Vector2i(indent_size, indent_size)
			)
			if (
				rect.position.x >= TEX_SIZE
				or rect.position.y >= TEX_SIZE
				or rect.end.x <= 0
				or rect.end.y <= 0
			):
				continue
			tex.blit_rect(rect, indent_tex)
