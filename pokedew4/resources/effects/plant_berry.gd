class_name PlantBerryEffect extends Effect

@export var crop:CropData
const crop_ref = preload("res://scenes/crop.tscn")

func apply(user,target,move=null,item=null):
    if target is Vector2:
        var tile = Refs.player.get_tile()
        var t:TileData = Refs.current_level.ground_layer.get_cell_tile_data(tile)
        if t.get_custom_data("can_plant_crop"):
            var new_crop=crop_ref.instantiate()
            Refs.current_level.trees_container.add_child(new_crop)
            new_crop.set_crop(crop,tile)
            Signals.add_obstruction.emit(target,crop)
            new_crop.global_position=target
            return true
