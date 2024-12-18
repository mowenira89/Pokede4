class_name _Tree extends Node2D
@onready var base: Sprite2D = $Base
@onready var tree: Sprite2D = $Tree
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pickup = preload("res://scenes/pickup.tscn")

@export var data:Treesource
@export var mature:bool
var stage=0
var growth=0
var hp
var stump_hp
var stump:bool=false

func _ready():
    Signals.ten_minutes_passed.connect(grow)

#used to plant trees from a seed
func set_tree(t:Treesource,location:Vector2):
    data=t
    base.texture=data.immature_sprites[0]
    hp=1
    collider.disabled=true
    global_position=location
    Refs.current_level.add_obstruction(global_position,self)
    
    

#used to create trees on load
func create_tree(d:Treesource, location:Vector2):
    data=d
    stage=data.immature_sprites.size()
    set_stage()
    global_position=location
    Refs.current_level.add_obstruction(location,self)
    
func grow():
    growth+=1
    if growth>=data.growth_time:
        stage+=1
        set_stage()
        
func set_stage():
    if stage<data.immature_sprites.size():
        base.texture=data.immature_sprites[stage]
        if stage>0:
            base.position=Vector2.ZERO
            hp=stage
            collider.disabled=false
    else:
        mature=true
        var index = randi_range(0,data.mature_sprites.size()-1)
        base.texture=data.stumps[index]
        tree.texture=data.mature_sprites[index]
        base.offset.y-=30
        tree.offset.y-=((tree.get_rect().size.y/2)-(base.get_rect().size.y/2))+30
        hp=data.hp
        Signals.ten_minutes_passed.disconnect(grow)
        base.position=Vector2.ZERO
    if stage!=0: collider.disabled=false
        
func get_broken(damage:int):
    if stage>0:
        hp-=damage
        if hp<=0:
            fall()
        
func fall():
    if mature and !stump:
        anim.play("fall")
        await anim.animation_finished
        tree.visible=false
        stump=true
        hp=data.stump_hp
        get_loot()
    else:
        get_loot()
        Signals.remove_obstruction.emit(global_position)
        queue_free()    
    
func get_loot():
    if !stump:
        if mature:
            var wood_amount=randi_range(data.min_wood,data.max_wood)
            var resin_amount=randi_range(1,5)
            var seed_amount=randi_range(1,4)
            for x in wood_amount:
                set_loot(data.wood)        
            for x in resin_amount:
                set_loot(data.resin)
            var seed = load("res://resources/items/"+data.seed+".tres")
            for x in seed_amount:
                set_loot(seed)
        else:
            var wood_amount = randi_range(1,stage+1)
            for x in wood_amount:
                set_loot(data.wood)
            var seed = load("res://resources/items/"+data.seed+".tres")
            set_loot(seed)
    else:
        var wood_amount = randi_range(1,4)
        for x in wood_amount:
            set_loot(data.wood)
                
func set_loot(i:ItemData,l=null):
    var p = pickup.instantiate()
    get_parent().add_child(p)
    var item = Item.new()
    item.set_item(i,1)
    p.create_pickup(item)
    if l!=null:
        p.global_position=l
    else:
        var x_coord = randi_range(global_position.x+30,global_position.x+300)
        p.global_position = Vector2(x_coord, global_position.y)
    
func interact():
    var item = InvManager.equipped()
    #add logic for forage here
    if item!=null and item.data is ToolData:
        if item.data.tool_type == ToolData.tool_types.AXE and stage>0:
            get_broken(item.data.damage)        
        if stage==0 and item.data.tool_type==ToolData.tool_types.HOE:
                var data = load("res://resources/items/"+data.seed+".tres")
                set_loot(data,global_position)
                queue_free()
                return
    
