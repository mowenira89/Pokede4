class_name Stockpile extends Station

@onready var inventory = chest.chest_inv
var requesting_goods = []


func interact():
    var item = InvManager.equipped()
    if item!=null:
        if item.data is ToolData:
            remove()
            return
    chest.open()

func remove():
    for x in chest.chest_inv.items:
        if x!=null:
            var p = pickup.instantiate()
            Refs.misc_holder.add_child(p)
            var x_coord = randi_range(-45,45)
            var y_coord = randi_range(-45,45)
            p.global_position=global_position+Vector2(x_coord,y_coord)
            p.create_pickup(x)
    placeable.remove()
