class_name Crop extends StaticBody2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

@onready var pest_sprite = $Sprite2D2

var data:CropData
var growth=0
var stage=0
var water:int=0
var tile:Vector2i
var in_range:bool=false
var growth_speed_modifier:float=0
var thirst_modifier:float=0
var happiness_modifier:float=0
var berry_growth_modifier:float=0
var pest_rate_modifier:float=0
var tenders:Array[Entity]=[]
var happiness=0
var pest:Pokemon=null
var in_pest_range=false


var berries:Item=null

const seed_image = preload("res://images/crops/AllTreeSeedIII.png")
const sapling_image = preload("res://images/crops/AllTreeSproutIII.png") 
func _ready():
    Signals.ten_minutes_passed.connect(grow)
    Signals.one_hour_passed.connect(_on_one_hour)
    
func reset_modifiers():
    growth_speed_modifier=0
    thirst_modifier=0
    happiness_modifier=0
    berry_growth_modifier=0
    pest_rate_modifier=0
    
func grow():
    reset_modifiers()
    if water>0 and pest==null:
        var mulch = Refs.current_level.mulch_plots
        if tile in mulch:
            mulch=mulch[tile]
        if mulch is MulchData:
            growth_speed_modifier+=mulch.growth_boost
            berry_growth_modifier=mulch.berry_boost
            happiness_modifier+=mulch.happines_boost
        if happiness+happiness_modifier>100:
            growth_speed_modifier+=1
        if happiness+happiness_modifier>200:
            growth_speed_modifier+=2   
        var water_source=Refs.current_level.watered_plots
        if tile in water_source:
            water_source[tile]-=data.thirst-thirst_modifier
            water+=data.thirst
        growth+=data.growth_speed+growth_speed_modifier
        
        if tenders.is_empty():
            happiness-=1
        
        #check stage growth    
        if growth>=data.growth_time:
            stage+=1
            set_stage()
            if stage==4:
                get_berries(berry_growth_modifier)
                Signals.ten_minutes_passed.disconnect(grow)
    if pest!=null:
        growth-=pest.get_stat(Entity.stats.Attk)

func get_berries(growth_modifier):
    var amount = randi_range(data.min_berries,data.max_berries+1)+berry_growth_modifier
    if happiness>100:amount+=1
    if happiness>200:amount+=2
    var berry_item = Item.new()
    berry_item.create_item(data._name.to_lower(),amount)
    berries=berry_item
        
func set_stage():
    if stage in [0,1]:
        collider.disabled=true
        if stage==0: sprite.texture=seed_image
        if stage==1: sprite.texture=sapling_image
    else:
        collider.disabled=false
        sprite.texture=data.sprites[stage-2]
    
func set_crop(d:CropData,t:Vector2i):
    data = d
    tile=t
    set_stage()

func interact():
    pick_berries(InvManager.inventory)
    if InvManager.equipped()!=null:
        var item = InvManager.equipped()
        


func pick_berries(inv:InvResource):
    if berries!=null:
        if inv.add(berries):
            berries=null
            stage=2
            set_stage()
            Signals.ten_minutes_passed.connect(grow)
        

func _on_one_hour():
    var tdrs = []
    for x in tenders:
        if x.state_machine.current_state is FarmingState:
            tdrs.append(x)
            
    if pest==null:
        var random = randi()%101+(tdrs.size()*10)
        
        if tile in Refs.current_level.mulch_plots:
            random+=Refs.current_level.mulch_plots.pesticide
        
        #if x ability do whatever
        #if x equipment do whatever
        if random<data.pest_rate:
            pest=data.pests.pick_random().duplicate()
            pest.create_pokemon(5,Pokemon.locations.FIELD)
            set_pest()
            
    for x in tdrs:
        var farm_stat = x.get_stat(Entity.stats.Farm)
        if pest==null:
            change_happiness(farm_stat/20)
            if x is Pokemon:
                x.get_exp("farm",ceil(happiness/100))
    if pest!=null:
        change_happiness(-10)
    

func change_happiness(d:int):
    happiness+=d+happiness_modifier

func _on_area_2d_area_entered(area: Area2D) -> void:
    if area.is_in_group('WorkerArea'):
        var fieldmon = area.get_parent()
        if fieldmon is Fieldmon:
            if fieldmon.state_machine.current_state is FarmingState:
                if fieldmon.mon not in tenders: tenders.append(fieldmon.mon)

func _on_area_2d_area_exited(area: Area2D) -> void:
    if area.is_in_group("WorkerArea"):
        var mon = area.get_parent().data
        if mon in tenders:tenders.erase(mon)


func set_pest():
    pest_sprite.texture=pest.image
    pest_sprite.visible=true
    
func remove_pest():
    pest_sprite.visible=false
    pest=null

func _on_area_2d_2_body_entered(body: Node2D) -> void:
    Signals.set_instruction.emit("Press F to Fight\nPress C to Shoo")
    in_pest_range=true

func _on_area_2d_2_body_exited(body: Node2D) -> void:
    Signals.close_instruction.emit()
    in_pest_range=false
