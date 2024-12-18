class_name Cookfire extends Machine

@onready var timer: Timer = $Timer
@onready var label: Label = $Label
@onready var progress_bar: ProgressBar = $Label/ProgressBar


var fuel_amount:int=0
var fueled:bool=false
var cooking:bool=false
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

func interact():
    super()
    if completed_object!=null:
        take_object()
    else:
        var item = InvManager.equipped()
        if item!=null:
            if item.data.fuel: 
                if change_fuel(item.data.fuel_amount):
                    InvManager.remove(item,1)
                    if input_item!=null:
                        start_recipe()
            elif item.data in acceptable_items:
                put_in_item(item,InvManager.inventory)

func put_in_item(item:Item,inventory:InvResource):
    if item not in acceptable_items: return false
    if input_item==null and !currently_processing:
        input_item=item.data
        inventory.remove(item,1)
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
            fueled_by_pokefire=true
            needs_fire=false
            x.available_fire-=1
            start_recipe()
            break

func fuel_by_pokefire():
    if fueled or input_item==null:return false
    else:
        fueled=true
        fueled_by_pokefire=true
        needs_fire=false
        start_recipe()
        return true


func start_recipe():
    var item = acceptable_items[input_item]
