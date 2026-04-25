class_name Player
extends CharacterBody2D

const TILE_SIZE: int = 16
const MOVE_DURATION: float = 0.1

var _moving: bool = false
var _walls_layer: int = -1

# Assumes TileMap sibling named "room_poc" (set by naddys_tiled_maps from filename)
@onready var _tilemap: TileMap = $"../room_poc"


func _ready() -> void:
	position = snap_to_grid(position, TILE_SIZE)
	for i: int in _tilemap.get_layers_count():
		if _tilemap.get_layer_name(i) == "Walls":
			_walls_layer = i
			break


func _unhandled_input(event: InputEvent) -> void:
	if _moving:
		return
	for action: String in ["move_up", "move_down", "move_left", "move_right"]:
		if event.is_action_pressed(action):
			_try_move(action)
			return


func _try_move(action: String) -> void:
	var offset: Vector2i = direction_to_offset(action)
	var target_pos: Vector2 = position + Vector2(offset) * TILE_SIZE
	if _is_wall(target_pos):
		return
	_moving = true
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_pos, MOVE_DURATION)
	tween.tween_callback(func() -> void: _moving = false)


func _is_wall(world_pos: Vector2) -> bool:
	if _walls_layer == -1:
		return false
	# Both Player and TileMap are direct children of the same root at (0,0);
	# local_to_map receives the position in the TileMap's local space.
	var cell: Vector2i = _tilemap.local_to_map(world_pos)
	return _tilemap.get_cell_source_id(_walls_layer, cell) != -1


static func direction_to_offset(action: String) -> Vector2i:
	match action:
		"move_up":    return Vector2i(0, -1)
		"move_down":  return Vector2i(0, 1)
		"move_left":  return Vector2i(-1, 0)
		"move_right": return Vector2i(1, 0)
	return Vector2i.ZERO


static func snap_to_grid(pos: Vector2, tile_size: int) -> Vector2:
	return Vector2(
		roundf(pos.x / tile_size) * tile_size,
		roundf(pos.y / tile_size) * tile_size,
	)
