class_name Mining extends Control

var colors = [Color.GRAY,Color.DIM_GRAY,Color.WEB_GRAY,Color.DARK_GRAY,Color.SLATE_GRAY,Color.LIGHT_SLATE_GRAY]

@export var mp:MineProfile

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var stone_ref = load("res://resources/items/stone.tres")
const pickup = preload("res://scenes/pickup.tscn")
@onready var task_label: Label = $TaskLabel

const message = preload("res://scenes/mining/loot_label.tscn")
var player:Entity

var loot_level:int=0

var stone_total=0
var common_total=0
var rare_total=0
var artifact_total=0


#mining modifier
var mm:int

var mining_level:int=0
var collapse_chance=0
var mining_progress=0

var active:bool=false
var mstat

var loot_level_dict = {
}

func start():
    set_totals()
    mstat = player.get_stat(Entity.stats.Mine)
    mm = mstat/10
    anim.play('move')
    visible=true
    Signals.switch_state.emit("battle")
    
func exit():
    anim.stop()
    visible=false
    Signals.switch_state.emit('normal')
    active=false
    
func set_totals():
    var mlevel = 0
    if mining_level<30:
        loot_level_dict = {'stone':mp.stones1,'common':mp.common1,'rare':mp.rare1,}
    elif mining_level>=30 and mining_level<60:
        loot_level_dict = {'stone':mp.stones1,'common':mp.common2,'rare':mp.rare2}
    elif mining_level>=60:
        loot_level_dict = {'stone':mp.stones3,'common':mp.common3,'rare':mp.rare3,"fossil":mp.fossil3}
    
    for x in loot_level_dict['stone']: 
        stone_total+=x.rarity
    for x in loot_level_dict['common']:
        common_total+=x.rarity
    for x in loot_level_dict['rare']:
        rare_total+=x.rarity
    if mining_level>=60:
        for x in loot_level_dict['fossil']:
            artifact_total+=x.rarity

func _on_area_2d_area_entered(area: Area2D) -> void:
    if area.is_in_group("MiningArea"):
        loot_level+=1

func _on_area_2d_area_exited(area: Area2D) -> void:
    if area.is_in_group("MiningArea"):
        loot_level-=1

func progress_mine(amount:int):
    mining_progress+=amount
    if mining_progress>16:
        mining_progress=0
        mining_level=clamp(mining_level+1,0,mstat)
        var s = "Mine Depth: "+str(mining_level)+"m"
        create_message(s,"#33ff55")
    
        
func regress_mine(amount:int):
    collapse_chance+=amount
    if randi()%255<collapse_chance:
            mining_level=clamp(mining_level-randi_range(1,10),0,255)
            create_message("Collapse!","#ff0000")
            create_message("Mine Depth: "+str(mining_level)+"m")
            collapse_chance=collapse_chance*.25
            mining_progress=0     


func on_pressed(p:Entity, inventory, poke_mine_level=null):
    var mstat = p.get_stat(Entity.stats.Mine)
    var _loot_level
    if poke_mine_level>0: _loot_level=poke_mine_level
    else: _loot_level = loot_level
    match _loot_level:
        0: 
            var skill = (mstat*2)-100
            regress_mine(skill)
        1:
            if randi()%101<50: 
                var skill = (mstat*2)-100
                regress_mine(skill)
            p.get_exp("mine",1)
        2:
            p.get_exp("mine",1)
            progress_mine(clamp(loot_level/2,1,2))
            regress_mine(1)
        3:
            p.get_exp("mine",2)
            progress_mine(clamp(loot_level/2,1,2)+mm)
        4:
            progress_mine(clamp(loot_level/2,1,2)+mm)
            p.get_exp("mine",3)
            if mstat>20:
                collapse_chance-=mm
            if mstat>80:
                get_loot(inventory)
    
    if mstat>35:
        collapse_chance-=mm
    if mstat>55:
        mining_progress+=mm

    get_loot(inventory)
    var e = (100-mstat)/10
    p.change_energy(-e)
    set_totals()
    
func grant_loot(loot:Array,inventory:InvResource):
    for x in loot:
        var m = message.instantiate()
        add_child(m)
        m.set_label(x.data.item_name, colors.pick_random())
        if !inventory.add(x):
            var p = pickup.instantiate()
            Refs.misc_holder.add_child(p)
            p.create_pickup(x)
            p.global_poition=get_parent().global_position
            
    
func get_loot(inventory):
    var loot = []
    var stone_amount = randi_range(1,loot_level+2)
    var stone_loot = Item.new()
    stone_loot.create_item("stone",stone_amount)
    loot.append(stone_loot)
    
    if loot_level==1:
        if randi()%255<10:
            while stone_total>0:
                var l = loot_level_dict['stone'].pick_random()
                stone_total-=l.rarity
                if stone_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=1
                    loot.append(i)            
            
    elif loot_level==2:
        if randi()%101<80:
            while stone_total>0:
                var l = loot_level_dict['stone'].pick_random()
                stone_total-=l.rarity
                if stone_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=1
                    loot.append(i)            
                
    elif loot_level==3:
        
        if randi()%101<30:
            while stone_total>0:
                var l = loot_level_dict['stone'].pick_random()
                stone_total-=l.rarity
                if stone_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=randi_range(1,4)
                    loot.append(i)            
                
        if randi()%101<60:
            while common_total>0:
                var l = loot_level_dict['common'].pick_random()
                common_total-=l.rarity
                if common_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=1
                    loot.append(i)        
    
        if randi()%101<20:
            while rare_total>0:
                var l = loot_level_dict['rare'].pick_random()
                rare_total-=l.rarity
                if rare_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=1
                    loot.append(i)

    elif loot_level==4:
        
        if randi()%101<10:
            while stone_total>0:
                var l = loot_level_dict['stone'].pick_random()
                stone_total-=l.rarity
                if stone_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=randi_range(4,6)
                    loot.append(i)            
                
        if randi()%101<50:
            while common_total>0:
                var l = loot_level_dict['common'].pick_random()
                common_total-=l.rarity
                if common_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=randi_range(1,3)
                    loot.append(i)        
    
        if randi()%101<20:
            while rare_total>0:
                var l = loot_level_dict['rare'].pick_random()
                rare_total-=l.rarity
                if rare_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=1
                    loot.append(i)    
                    
        if mining_level>=60 and randi()%101<2:
            while artifact_total>0:
                var l = loot_level_dict['fossil'].pick_random()
                artifact_total-=l.rarity
                if artifact_total<=0:
                    var i = Item.new()
                    i.data=l
                    i.quantity=1
                    loot.append(i)

    grant_loot(loot,inventory)
                    
func create_message(s:String,c:Color="#ffffff"):
    var m = message.instantiate()
    add_child(m)
    m.set_label(s,c)
