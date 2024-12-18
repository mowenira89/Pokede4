extends Resource
class_name IPokemon

enum nats {Hardy, Lonely, Brave, Adamant, Naughty, Bold,Docile,Relaxed,Impish,Lax,Timid,Hasty,Serious,Jolly,Naive,Modest,Mild,Quiet,Bashful,Rash,Calm,Gentle,Sassy,Careful,Quirky}


@export var species:String
@export var level = 1
var ivs = [0,0,0,0,0,0]
var evs = [0,0,0,0,0,0]
var hadsads = [0,0,0,0,0,0]
var status = []
var xp = 0
var xp_to_next_lvl = 1

var species_data: get = get_species_data
var types: get = get_types

func get_types():
    return Pokemon.pkmn[species]["types"]

func get_species_data():
    return Pokemon.pkmn[species]

var buffs = []

var max_health = hadsads[0]
var current_hp = 0
var nickname = species
var nature = nats
var ability = null
var current_energy
var max_energy

var happiness = 40
const max_happiness = 255

var likes = []
var previous_likes = []
var dislikes = []
var skills = {E.skills.Farm:0,E.skills.Mine:0,E.skills.Forage:0,E.skills.Craft:0,E.skills.Perform:0,E.skills.Fishing:0, E.skills.Cook:0}
var skillEVs={E.skills.Farm:0, E.skills.Mine:0, E.skills.Forage:0,E.skills.Craft:0,E.skills.Perform:0, E.skills.Fishing:0, E.skills.Cook:0}
var skillIVs={E.skills.Farm:0, E.skills.Mine:0, E.skills.Forage:0,E.skills.Craft:0,E.skills.Perform:0, E.skills.Fishing:0, E.skills.Cook:0}
var task

var moves = []
var learned_moves = []

var location = "Field"
var texture:String
var back_texture:String
var wild = true
var inventory = []


var exps = {E.skills.Farm:0,
            E.skills.Forage:0,
            E.skills.Craft:0,
            E.skills.Mine:0,
            E.skills.Perform:0, 
            E.skills.Cook:0,
            E.skills.Fighting:0}
            
var to_next_levels = {E.skills.Farm:0,
            E.skills.Forage:0,
            E.skills.Craft:0,
            E.skills.Mine:0,
            E.skills.Perform:0, 
            E.skills.Cook:0,
            E.skills.Fighting:0}



var flinch=false
var confusion=false
var cursed = false
var toxic = false 
var protected = false
var turns_poisoned = 0
var encore = false

func _init(species, lvl):
    level = lvl
    self.species = species
    self.nickname = species
    texture="res://Assets/Sprites/Pokemon/"+species+".png"
    back_texture = "res://Assets/Sprites/Pokemon/"+species+"_back.png"
    
    #set naure
    var natures = []
    for i in nats:
        natures.append(i)
    nature = natures.pick_random()
    #set ivs
    for i in range(0,6):
        ivs[i] = randi_range(0,32)
    for i in skillIVs:
        skillIVs[i]=randi_range(0,32)
    #set_stats	
    happiness = 100
    set_stats()
    current_hp=get_stat(E.stats.HP)
    current_energy = get_stat(E.stats.Energy)
    set_likes()
    moves = set_moves()	
    set_ability()
    inventory.resize(species_data['inv'])
    
    
    
func set_stats():
    var base = species_data['hadsads']
    var health = floor(((2*base[0]+ivs[0]+(evs[0]/4))*level)/100)+level+10	
    hadsads[0]=health
    for i in range(1,6):
        hadsads[i]=floor((floor((2*base[i]+ivs[i]+(evs[i]/4))*level)/100)+5)
    max_energy = ((get_stat(E.stats.Speed)+get_stat(E.stats.HP))/2)
    for x in skills:
        var species_skill = species_data['species_skills'][x]*10
        skills[x] = (((species_skill*2)+skillIVs[x]+(skillEVs[x]/4))*level/100)+5
    inventory.resize(get_stat(E.stats.InvSize))
    
func set_nature_buff():	
    var buff = Buff.new()
    buff.amount=1.1
    buff.method="m"
    buff.type = Buff.types.Permanent
    buff.origin = Buff.origins.NATURE
    
    var debuff = Buff.new()
    debuff.amount=.9
    debuff.method="m"
    debuff.type = Buff.types.Permanent
    debuff.origin = Buff.origins.NATURE
    
    match self.nature:
        nats.Lonely:
            buff.stat=1
            debuff.stat = 2		
        nats.Brave:
            buff.stat=1
            debuff.stat=5
        nats.Adamant:
            buff.stat=1
            debuff.stat=3
        nats.Naughty:
            buff.stat=1
            debuff.stat=4
        nats.Bold:
            buff.stat=2
            debuff.stat=1
        nats.Relaxed:
            buff.stat=2
            debuff.stat=5
        nats.Impish:
            buff.stat=2
            debuff.stat=3
        nats.Lax:
            buff.stat=2
            debuff.stat=4
        nats.Timid:
            buff.stat=5
            debuff.stat=1
        nats.Hasty:
            buff.stat=5
            debuff.stat=2
        nats.Jolly:
            buff.stat=5
            debuff.stat=3
        nats.Naive:
            buff.stat=5
            debuff.stat=4
        nats.Modest:
            buff.stat=3
            debuff.stat=1
        nats.Mild:
            buff.stat=3
            debuff.stat=2
        nats.Quiet:
            buff.stat=3
            debuff.stat=5
        nats.Rash:
            buff.stat=3
            debuff.stat=4
        nats.Calm:
            buff.stat=4
            debuff.stat=1
        nats.Gentle:
            buff.stat=4
            debuff.stat=2
        nats.Sassy:
            buff.stat=4
            debuff.stat=5
        nats.Careful:
            buff.stat=4
            debuff.stat=3
    
    buffs.append(buff)
    buffs.append(debuff)
    
        
func set_likes():
    match self.nature:
        nats.Hardy or nats.Lonely or nats.Brave or nats.Adamant or nats.Naughty:
            add_like(E.likes.Spicy)
        nats.Bold or nats.Docile or nats.Relaxed or nats.Impish or nats.Lax:
            add_like(E.likes.Sour)
        nats.Timid or nats.Hasty or nats.Serious or nats.Jolly or nats.Naive: 
            add_like(E.likes.Sweet)
        nats.Modest or nats.Mild or nats.Quiet or nats.Bashful or nats.Rash:
            add_like(E.likes.Dry)
        nats.Calm or nats.Gentle or nats.Sassy or nats.Careful or nats.Quirky:
            add_like(E.likes.Bitter)
    for t in Pokemon.pkmn[species]["types"]:
        match t:
            'grass':if randi()%100 < 90: add_like(E.likes.Foliage)
            'fire':if randi()%100 < 90: add_like(E.likes.Fire)
            'water':if randi()%100 < 90: add_like(E.likes.Water)
            'dark':if randi()%100 < 90: add_like(E.likes.Dark)
            'ghost':if randi()%100 < 70: add_like(E.likes.Macabre)
            'Rock':if randi()%100 < 70: add_like(E.likes.Polish)
            'bug':if randi()%100 < 70: add_like(E.likes.Foliage)
            'psychic':
                if randi()%100 < 80: add_like(E.likes.Meditation)
                if randi()%100 < 40: add_like(E.likes.Books)
            'fight':
                if randi()%100 < 90: add_like(E.likes.Fight)
                if randi()%100 < 40: add_like(E.likes.Craft)
        for l in species_data['species_likes']:
            if randi()%100 < species_data['species_likes'][l]:
                add_like(l)
    if likes.size()<2:
        var e = E.likes.size()
        var num = randi()%e
        add_like(num)

func add_like(like):
    if like not in likes: likes.append(like)
    if like not in previous_likes: previous_likes.append(like)
    
func add_move(move):
    if move not in moves: moves.append(move)
    if move not in learned_moves: learned_moves.append(move)
    
func set_moves():
    var learnset = species_data['learnset']
    var current_moves = []
    for i in learnset:
        if i <= level:	
            if learnset[i].contains(","):
                var moves = learnset[i].split(',')
                for x in moves:
                    current_moves.append(x)
            else:
                current_moves.append(learnset[i])	
    var moves = []
    if current_moves.size() > 4: 
        while moves.size()<4:	
            var r = current_moves.pick_random()
            if r not in moves:moves.append(r)
    else: moves = current_moves
    return moves
    

func set_ability():
    var ability = species_data['abilities'].pick_random()
    
func add_health(amount):
    current_hp+=amount
    if current_hp>hadsads[0]:
        current_hp=hadsads[0]

#HP,Attack,Def,SpA,SpD,Speed,Accuracy,Evasion,Crit,Farm,Mine,Craft,Forage,Cook
func get_stat(stat:E.stats):
    var _stat
    match stat:
        E.stats.HP: _stat=hadsads[0]
        E.stats.Attack: _stat=hadsads[1]
        E.stats.Def: _stat=hadsads[2]
        E.stats.SpA: _stat=hadsads[3]
        E.stats.SpD: _stat=hadsads[4]
        E.stats.Speed:_stat=hadsads[5]
        E.stats.Acc:_stat=100
        E.stats.Evasion:_stat=100
        E.stats.Crit:_stat=220
        E.stats.Farm:_stat = skills[E.skills.Farm]
        E.stats.Craft:_stat = skills[E.skills.Craft]
        E.stats.Mine: _stat = skills[E.skills.Mine]
        E.stats.Forage:_stat=skills[E.skills.Forage]
        E.stats.Perform:_stat=skills[E.skills.Perform]
        E.stats.Fishing:_stat=skills[E.skills.Fishing]
        E.stats.Cook:_stat = skills[E.skills.Cook]
        E.stats.InvSize:_stat = species_data['inv']			
        E.stats.Energy:_stat = max_energy
        E.stats.WorkSpeed:_stat = get_stat(E.stats.Speed)+happiness
    for buff in buffs:
        if buff.stat==stat:
            _stat = buff.apply(_stat)
    return _stat	


func get_next_level_amount(stat):
    var base = 50 * skills[stat]
    match stat:
        E.skills.Farm:
            if 'grass' in types: base/=2	
        E.skills.Craft:
            if 'psychic' in types or 'fighting' in types: base/=2
        E.skills.Mine:
            if 'rock' in types or 'ground' in types: base/=2
        E.skills.Cook:
            if 'fire' in types:base/=2
        E.skills.Fighting:
            if 'fighting' in types: base/2
    to_next_levels[stat]=base
            
func be_caught():
    wild=false
    location='ball'
    Global.player_pokemon.append(self)

func increase_energy(amount):
    current_energy+=amount
    
    if current_energy>get_stat(E.stats.Energy):
        current_energy = get_stat(E.stats.Energy)
    if current_energy<0: current_energy=0
        
func increase_health(amount):
    current_hp+=amount
    if current_hp>get_stat(E.stats.HP):
        current_hp = get_stat(E.stats.HP)
    if current_hp<0: current_hp=0

func increase_happiness(amount):
    happiness+=amount
    if happiness>255:
        happiness=255
    if happiness<0: happiness=0
    
func get_exp(stat:E.skills, amount):
    exps[stat]+=amount
    skillEVs[stat]+=1
    if exps[stat]>=to_next_levels[stat]:
        skills[stat]+=1
        get_next_level_amount(stat)
