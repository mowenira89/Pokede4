class_name Cursor extends Sprite2D

var tilemap:TileMapLayer

func _ready():
    tilemap=get_parent()
    global_position = tilemap.map_to_local(tilemap.local_to_map(Refs.player.global_position))
    
