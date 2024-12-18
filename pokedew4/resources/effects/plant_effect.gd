class_name PlantEffect extends Effect

@export var data:Treesource

func apply(user,target,move=null,item=null):
    if target is Vector2:
        if target not in Refs.current_level.obstructions:
            var tile = Refs.player.get_tile()
            var t:TileData = Refs.current_level.ground_layer.get_cell_tile_data(tile)
            if t.get_custom_data("can_plant_tree"):
                Signals.plant_tree.emit(data,target)
                return true
