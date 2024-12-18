class_name PlaceableItemData extends ItemData

@export var path_to_scene:PackedScene

func set_sprite(sprite):
    if sprite == Refs.player.equipped:
        sprite.texture=null
    else:
        super(sprite)
