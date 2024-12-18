class_name Pokemon extends Entity

enum nats {Hardy, Lonely, Brave, Adamant, Naughty, Bold,Docile,Relaxed,Impish,Lax,Timid,Hasty,Serious,Jolly,Naive,Modest,Mild,Quiet,Bashful,Rash,Calm,Gentle,Sassy,Careful,Quirky}
enum locations {FIELD,BATTLE,BALL}

const fieldmon = preload("res://scenes/pokemon.tscn")
var current_fieldmon:Fieldmon

var location:locations=locations.FIELD

var holding_produce:Item
var held_item:Item

var friendship:int

var endearment:int=0
var grudge:int=0
var fear:int
var tenacity:int

@export var produce:Array[Produce]
@export var rarity:int

var liked_flavor:Array[Food.flavors]
var disliked_flavor:Array[Food.flavors]
var liked_scents
var disliked_scents


func create_pokemon(l:int,loc:locations=locations.FIELD):
    nickname=species
    for x in level:
        level[x]=l
    happiness = base_happiness
    location=loc
    
    fear=randi()%255
    tenacity=randi()%255
    
    nature = randi()%nats.size()
    var buff = ChangeStat.new()
    var debuff = ChangeStat.new()
    var increase:Entity.stats
    var decrease:Entity.stats
    match nature:
        nats.Lonely:
            increase=stats.Attk
            decrease=stats.Def		
        nats.Brave:
            increase=stats.Attk
            decrease=stats.Speed
        nats.Adamant:
            increase=stats.Attk
            decrease=stats.Sattk
        nats.Naughty:
            increase=stats.Attk
            decrease=stats.Sdef
        nats.Bold:
            increase=stats.Def
            decrease=stats.Attk
        nats.Relaxed:
            increase=stats.Def
            decrease=stats.Speed
        nats.Impish:
            increase=stats.Def
            decrease=stats.Sattk
        nats.Lax:
            increase=stats.Def
            decrease=stats.Sdef
        nats.Timid:
            increase=stats.Speed
            decrease=stats.Attk
        nats.Hasty:
            increase=stats.Speed
            decrease=stats.Def
        nats.Jolly:
            increase=stats.Speed
            decrease=stats.Sattk
        nats.Naive:
            increase=stats.Speed
            decrease=stats.Sdef
        nats.Modest:
            increase=stats.Sattk
            decrease=stats.Attk
        nats.Mild:
            increase=stats.Sattk
            decrease=stats.Def
        nats.Quiet:
            increase=stats.Sattk
            decrease=stats.Speed
        nats.Rash:
            increase=stats.Sattk
            decrease=stats.Sdef
        nats.Calm:
            increase=stats.Sdef
            decrease=stats.Attk
        nats.Gentle:
            increase=stats.Sdef
            decrease=stats.Def
        nats.Sassy:
            increase=stats.Sdef
            decrease=stats.Speed
        nats.Careful:
            increase=stats.Sdef
            decrease=stats.Sattk
    
    buff.create_buff(increase,1.1,true,false)
    buffs.append(buff)
    debuff.create_buff(decrease,.9,true,false)
    buffs.append(debuff)
    
    match self.nature:
        nats.Hardy or nats.Lonely or nats.Brave or nats.Adamant or nats.Naughty:
            add_like("flavor", Food.flavors.Spicy)
        nats.Bold or nats.Docile or nats.Relaxed or nats.Impish or nats.Lax:
            add_like("flavor",Food.flavors.Sour)
        nats.Timid or nats.Hasty or nats.Serious or nats.Jolly or nats.Naive: 
            add_like("flavor",Food.flavors.Sweet)
        nats.Modest or nats.Mild or nats.Quiet or nats.Bashful or nats.Rash:
            add_like("flavor",Food.flavors.Dry)
        nats.Calm or nats.Gentle or nats.Sassy or nats.Careful or nats.Quirky:
            add_like("flavor",Food.flavors.Bitter)
    
    for x in ivs:
        ivs[x]=randi_range(0,32)
    
    hp=get_stat(Entity.stats.HP)
    energy = get_stat(Entity.stats.Energy)
    
    for x in level_to_next:
        get_next_exp_level(x)
    #assign moves
    var ll=get_level()
    for x in moves:
        
        if x < ll:
            learned_moves.append(moves[x])
    var lll = learned_moves.size()-1
    for x in clamp(lll,0,4):
        current_moves.append(learned_moves[lll-1-x])
    
func add_like(type:String, like):
    match type:
        'flavor':
            if like not in liked_flavor: liked_flavor.append(like)
        'scent':
            if like not in liked_scents: liked_scents.append(like)
    
func get_nature_name(num:int):
    var enum_names = nats.keys()
    return enum_names[num]

func change_happiness(d:int):
    happiness = clamp(happiness+d,-255,255)

func taste(f:Food.flavors, flavor_profile:int,bonus):
    if f in liked_flavor:
        change_happiness((6+bonus)*flavor_profile)
    elif f in disliked_flavor:
        change_happiness(-(6+bonus)*flavor_profile)

func switch_out():
    for x in range(buffs.size()-1,-1,-1):
        if buffs[x].lost_on_switch_out:
            buffs.erase(x)

func pokemon_go():
    var p = fieldmon.instantiate()
    Refs.current_level.fieldmon.add_child(p)
    p.set_mon(self)
    p.global_position = Refs.player.get_cursor_position()
    location=locations.FIELD
    current_fieldmon=p
    for m in current_moves:
        if !m.passive_effect.is_empty():
            for x in m.passive_effect:
                x.apply(self,self,m)
    
func pokemon_return():
    location=locations.BALL
    current_fieldmon.queue_free()
    current_fieldmon=null
    
func be_caught():
    Refs.add_pokemon(self)
