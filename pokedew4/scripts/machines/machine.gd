class_name Machine extends Station

enum fuel_types {MANUAL,FIRE,WATER,ICE,ELECTRIC}

@export var acceptable_items:Dictionary

var fuel

var input_item:ItemData

var needs_fire:bool=false
var needs_ice:bool=false
var needs_electric:bool=false
var needs_water:bool=false
var needs_psi:bool=false

var time_to_complete:int=0
var completed_object:Item
var currently_processing:bool=false
var fueled_by_pokefire:bool=false


func take_object():
    if completed_object!=null:
        if InvManager.add(completed_object):
            completed_object=null

func start_recipe():
    Signals.ten_minutes_passed.connect(ten_minutes)
    time_to_complete=acceptable_items[input_item].time
    currently_processing=true
    
func ten_minutes():                
    time_to_complete-=1
    if fueled_by_pokefire: time_to_complete-=1
    if time_to_complete<=0:
        finish_good()

func finish_good():
    var item = Item.new()
    item.quantity=1
    item.data=acceptable_items[input_item].item
    var tilemap = Refs.player.tilemap
    var tile = tilemap.local_to_map(global_position)
    var surrounding = tilemap.get_surrounding_cells(tile)
    for x in surrounding:
        var y = tilemap.map_to_local(x)
        if x in Refs.current_level.obstructions:
            if Refs.current_level.obstructions[x] is Stockpile:
                if Refs.current_level.obstruction[x].add_to_chest(item):
                    input_item=null
                    Signals.ten_minutes_passed.disconnect(ten_minutes)
                    return
                else:
                    set_output(item)
        
func set_output(i:Item):
    completed_object=i
    input_item=null
    Signals.ten_minutes_passed.disconnect(ten_minutes)

func interact():
    super()
    
