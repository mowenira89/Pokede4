class_name MulchEffect extends Effect

func apply(user,target,move=null,item=null):
    if item!=null and target is Vector2 and item.data is MulchData:
        var ground = Refs.current_level.ground_layer
        var tree = Refs.current_level.tree_layer
        var tile = ground.local_to_map(target)
        var tiledata = ground.get_cell_tile_data(tile)
        var mulchable = tiledata.get_custom_data("can_mulch")
        if mulchable:
            Refs.current_level.add_mulch(tile,item.data)
            tree.set_cell(tile,2,Vector2(0,0))
            return true
