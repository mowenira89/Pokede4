class_name Kiln extends Machine
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var output_sprite: Sprite2D = $Sprite2D


func interact():
    super()
    if completed_object!=null:
        take_object()
    else:
        var item = InvManager.equipped()
        if item!=null:
            if item.data in acceptable_items:
                if input_item==null:
                    if InvManager.remove(item,10):
                        input_item=item.data
                        start_recipe()
           
                
func start_recipe():
    super()
    sprite.frame=1

func set_output(item):
    super(item)
    sprite.frame=0
    output_sprite.texture=completed_object.data.image
    output_sprite.visible=true
    
func take_object():
    super()
    output_sprite.visible=false
