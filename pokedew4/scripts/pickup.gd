class_name Pickup extends Node2D

var item:Item
@onready var sprite: Sprite2D = $Sprite2D

func create_pickup(i:Item):
    item = i
    sprite.texture = item.data.image

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        if InvManager.add(item):
            queue_free()
