class_name WateringEffect extends Effect

func apply(user,target,move=null,item=null):
    if target is Vector2:
        var tilemap:TileMapLayer = Refs.current_level.ground_layer
        var target_tile = tilemap.local_to_map(target)
        var tile_data = tilemap.get_cell_tile_data(target_tile)
        var tillability = tile_data.get_custom_data("can_water")
        if tillability:
            tilemap.set_cell(target_tile,0,Vector2(1,0))
            Refs.current_level.add_watered_plot(target_tile)
