extends Node

const SNOW_CHUNK: PackedScene = preload("res://Systems/Weather/snow_chunk.tscn")

signal update_snow(body: Node3D)

var tracked_bodies: Dictionary[Node3D, Vector3]
var tmp_image: TextureRect
var chunks: Dictionary[Vector2i, DrawableTexture2D] = {}

func _ready() -> void:
	tmp_image = TextureRect.new()
	TransitionHandler.transition_started.connect(_on_transition_started)
	add_child(tmp_image)


func _on_transition_started() -> void:
	tracked_bodies = {}


func _physics_process(_delta: float) -> void:
	for body: Node3D in tracked_bodies.keys():
		var old_pos: Vector3 = tracked_bodies[body]
		if body.position.distance_squared_to(old_pos) > 1.0:
			tracked_bodies[body] = body.position
			update_snow.emit(body)


func entered_chunk(chunk_pos: Vector2i) -> void:
	print(chunk_pos)
	for x: int in range(-1, 2):
		for y: int in range(-1, 2):
			var pos: Vector2i = Vector2i(chunk_pos.x + x, chunk_pos.y + y)
			if not chunks.has(pos):
				create_chunk(pos)


func create_chunk(pos: Vector2i) -> void:
	var new_chunk: SnowChunk = SNOW_CHUNK.instantiate()
	var real_pos: Vector2 = SnowChunk.CHUNK_SIZE * Vector2(pos)
	new_chunk.position = Vector3(real_pos.x, 0.0, real_pos.y)
	new_chunk.pos = pos
	
	WorldData.add_child(new_chunk)
