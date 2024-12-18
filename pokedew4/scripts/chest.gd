class_name Chest extends Node2D
@onready var chest: Control = $Chest
@onready var placeable: Placeable = $Placeable
const pickup = preload("res://scenes/pickup.tscn")

func interact():
    var item = InvManager.equipped()
    if item!=null:
        if item.data is ToolData:
            remove()
            return
    chest.open()

func remove():
    for x in chest.chest_inv:
        if x!=null:
            var p = pickup.instantiate()
            Refs.misc_holder.add_child(p)
            var x_coord = randi_range(-45,45)
            var y_coord = randi_range(-45,45)
            p.global_position=global_position+Vector2(x_coord,y_coord)
            p.create_pickup(x)
    placeable.remove()
