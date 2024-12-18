class_name PlacableMine extends Placeable

var mining_area:Area2D

func area_entered(area:Area2D):
    super(area)
    if area.is_in_group("MiningRegion"):
        mining_area=area
        
func area_exited(area:Area2D):
    super(area)
    if area.is_in_group("MiningRegion"):
        mining_area=null
        
func attempt_placement(c:Callable,d:ItemData):
    if mining_area!=null:
        super(c,d)
        get_parent().mine=mining_area.get_parent()
        get_parent().init()
