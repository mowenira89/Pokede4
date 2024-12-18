class_name Pickup2 extends StaticBody2D

var item:Item
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

func create_pickup(i:Item):
    item = i
    sprite.texture = item.data.image

func interact():
    if InvManager.add(item):
        Refs.current_level.remove_obstruction(global_position)
        queue_free()

func invisible():
    collider.disabled=true
    visible=false
