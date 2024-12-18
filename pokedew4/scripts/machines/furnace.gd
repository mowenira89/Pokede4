class_name Furnace extends Machine

@onready var fire_sprite: Sprite2D = $FireSprite
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var output_sprite: Sprite2D = $OutputSprite

var fueled:bool
var fuel_amount:int=0
var working_recipe:ItemData=null


func interact():
    super()
    if completed_object!=null:
        take_object()
    else:
        var item = InvManager.equipped()
        if item!=null:
            if item.data.fuel and item.data.item_name!="Wood":
                if change_fuel(item.data.fuel_amount):
                    InvManager.remove(item,1)
                    if input_item!=null:
                        start_recipe()
            elif item.data in acceptable_items:
                put_in_item(item,InvManager.inventory)
           
func put_in_item(item:Item,inventory):
    if item not in acceptable_items: return false
    if input_item==null and !currently_processing:
        input_item=item.data
        if inventory==InvManager.inventory:
            InvManager.remove(item,1)
        if fueled:
            start_recipe()
            return true
        else:
            needs_fire=true
            get_pokefire()
            return true
    return false
                 
func get_pokefire():
    for x in assigned_fieldmon:
        if x.available_fire>0:
            fueled=true
            needs_fire=false
            x.available_fire-=1
            start_recipe()
            break

func fuel_by_pokefire():
    if fueled or input_item==null:return false
    else:
        fueled=true
        fueled_by_pokefire=true
        start_recipe()
        return true

func change_fuel(d:int):
    if fuel_amount+d>16:
        return false
    fuel_amount=clamp(fuel_amount+d,0,16)
    if fuel_amount>0:
        fueled=true
        label.text=str(fuel_amount)
        label.visible=true
    else: 
        fueled=false
        label.visible=false
    return true
    
func start_recipe():
    super()
    sprite_2d.frame=1
    
func ten_minutes():            
    super()
        
func set_output(i:Item):
    super(i)
    i.data.set_sprite(output_sprite)
    output_sprite.visible=true
    sprite_2d.frame=0
    fueled_by_pokefire=false
    

func take_object():
    super()
    output_sprite.visible=false
