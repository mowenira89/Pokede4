class_name Entity extends Resource

enum stats {HP,Attk,Def,Sattk,Sdef,Speed,Farm,Mine,Forage,Perform,Cook,Craft,Fishing,Energy,CritRate,Accuracy,Evasion,Battle,WorkSpeed}
enum types {Normal,Fire,Water,Grass,Electric,Ground,Bug,Rock,Ice,Fighting,Psychic,Dragon,Dark,Steel,Fairy,Poison,Flying,Ghost}
enum egg_groups {Monster,Fairy,Human,Field,Flying,Bug,Water1,Water2,Water3,Grass,Amorphous,Mineral,Ground,Dragon,Asexual}
enum main_status{PSN,PRLZ,SLP,FRZ,BRN,FNT}
enum hidden_statuses {Confusion,Infatuation,FlashFire,Underground,Flying}


const type_profile = {
    types.Normal:{'weakness':[types.Fighting],'resist':[],'immune':[types.Ghost]},
    types.Fire:{'weakness':[types.Water,types.Rock,types.Ground],'resist':[types.Bug,types.Grass,types.Fire,types.Steel,types.Ice,types.Fairy],'immune':[]},
    types.Water:{'weakness':[types.Electric,types.Grass],'resist':[types.Fire,types.Water,types.Ice,types.Steel],'immune':[]},
    types.Grass:{'weakness':[types.Fire,types.Flying,types.Poison,types.Ice,types.Bug],'resist':[types.Ground,types.Water,types.Grass,types.Electric],'immune':[]},
    types.Electric:{'weakness':[types.Ground],'resist':[types.Flying,types.Electric,types.Steel],'immune':[]},
    types.Ground:{'weakness':[types.Water,types.Grass,types.Ice],'resist':[types.Rock,types.Poison],'immune':[types.Electric]},
    types.Bug:{'weakness':[types.Flying,types.Rock,types.Fire],'resist':[types.Fighting,types.Ground,types.Grass],'immune':[]},
    types.Rock:{'weakness':[types.Ground,types.Fighting,types.Steel,types.Water,types.Grass],'resist':[types.Normal,types.Flying,types.Poison,types.Fire],'immune':[]},
    types.Ice:{'weakness':[types.Fighting,types.Rock,types.Fire,types.Steel],'resist':[types.Ice],'immune':[]},
    types.Fighting:{'weakness':[types.Flying,types.Psychic,types.Fairy],'resist':[types.Dark,types.Bug,types.Rock],'immune':[]},
    types.Psychic:{'weakness':[types.Bug,types.Ghost,types.Dark],'resist':[types.Fighting,types.Psychic],'immune':[]},
    types.Dragon:{'weakness':[types.Ice,types.Dragon,types.Fairy],'resist':[types.Fire,types.Electric,types.Water,types.Grass],'immune':[]},
    types.Dark:{'weakness':[types.Bug,types.Fighting,types.Fairy],'resist':[types.Dark,types.Ghost],'immune':[types.Psychic]},
    types.Steel:{'weakness':[types.Fighting,types.Ground,types.Fire],'resist':[types.Normal,types.Flying,types.Rock,types.Bug,types.Steel,types.Grass,types.Psychic,types.Ice,types.Dragon,types.Fairy],'immune':[types.Poison]},
    types.Fairy:{'weakness':[types.Poison,types.Steel],'resist':[types.Fighting,types.Bug,types.Dark],'immune':[types.Dragon]},
    types.Poison:{'weakness':[types.Ground,types.Psychic],'resist':[types.Fighting,types.Poison,types.Grass,types.Bug,types.Fairy],'immune':[]},
    types.Flying:{'weakness':[types.Rock,types.Ice,types.Electric],'resist':[types.Fighting,types.Bug,types.Grass],'immune':[types.Ground]},
    types.Ghost:{'weakness':[types.Ghost,types.Dark],'resist':[types.Poison,types.Bug],'immune':[types.Normal,types.Fighting]},  
}

@export var image:Texture2D
@export var species:String
@export var num:int
@export var type:Array[types]
@export var base_stats:Dictionary = {'hp':0,'attk':0,'def':0,'sattk':0,'sdef':0,'speed':0,'farm':0,'mine':0,'forage':0,'cook':0,'craft':0,'perform':0,'fishing':0,'energy':0}
@export var base_happiness:int
@export var height:int
@export var weight:int
@export var base_exp:int
@export var capture_rate:int
@export var abilities:Array[String]
@export var moves:Dictionary
@export var egg_moves:Array
@export var egg_group:Array[egg_groups]
@export var tutor_moves:Array
@export var machine_moves:Array
@export var hatch_counter:int
var learned_moves=[]
var current_moves=[]

var follower:Pokemon

var nature:Pokemon.nats
var ability:Ability
var status
var hidden_status = []
var hp:int
var energy:int
var buffs: Array[Buff] = []
var id:String

var happiness:int

var known_crafts=[]
var known_recipes=[]

var level = {
    'battle':1,
    'farm':1,
    'mine':1,
    'forage':1,
    'cook':1,
    'perform':1,
    'craft':1,
}

var exp = {
    'battle':1,
    'farm':1,
    'mine':1,
    'forage':1,
    'cook':1,
    'perform':1,
    'craft':1,    
}

var level_to_next = {
    'battle':1,
    'farm':1,
    'mine':1,
    'forage':1,
    'cook':1,
    'perform':1,
    'craft':1,
}

var ivs = {stats.HP:0,stats.Attk:0,stats.Def:0,stats.Sattk:0,stats.Sdef:0,stats.Speed:0,stats.Farm:0,stats.Mine:0,stats.Forage:0,stats.Cook:0,stats.Craft:0,stats.Perform:0,stats.Fishing:0}
var evs = {stats.HP:0,stats.Attk:0,stats.Def:0,stats.Sattk:0,stats.Sdef:0,stats.Speed:0,stats.Farm:0,stats.Mine:0,stats.Forage:0,stats.Cook:0,stats.Craft:0,stats.Perform:0,stats.Fishing:0}

var nickname:String

func get_stat(s:stats):
    var _stat_amount:int=0
    match s:
        stats.HP:
            _stat_amount = floor(((2*base_stats['hp']+ivs[stats.HP]+(evs[stats.HP]/4))*level['battle'])/100)+level['battle']+10
        stats.Attk:
            _stat_amount = _get_stat('attk',stats.Attk,'battle')
        stats.Def:
            _stat_amount = _get_stat('def',stats.Def,'battle')
        stats.Sattk:
            _stat_amount = _get_stat('sattk',stats.Sattk,'battle')
        stats.Sdef:
            _stat_amount = _get_stat('sdef',stats.Sdef,'battle')
        stats.Speed:
            _stat_amount = _get_stat('speed',stats.Speed,'battle')
        stats.Farm:
            _stat_amount = _get_stat('farm',stats.Farm,'farm')
        stats.Mine:
            _stat_amount = _get_stat('mine', stats.Mine,'mine')
        stats.Forage:
            _stat_amount = _get_stat('forage',stats.Forage,'forage')
        stats.Perform:
            _stat_amount = _get_stat('perform',stats.Perform,'perform')
        stats.Cook:
            _stat_amount = _get_stat('cook',stats.Cook,'cook')
        stats.Craft:
            _stat_amount = _get_stat('craft',stats.Craft,'craft')
        stats.Fishing:
            _stat_amount = ((2*base_stats['fishing']*level['forage'])/100)+5
        stats.Energy:
            _stat_amount = base_stats['energy']
        stats.CritRate:
            _stat_amount = 95
        stats.Evasion:
            _stat_amount=150
        stats.Accuracy:
            _stat_amount=150
        stats.WorkSpeed:
            _stat_amount = (200-(get_stat(stats.Speed)+happiness))/20
    for buff in buffs:
        if buff.has_method('affect_stat') and buff.stat==s:
            _stat_amount = buff.affect_stat(_stat_amount)
    return _stat_amount    


func _get_stat(b:String, i:stats,l:String):
    return floor((floor((2*base_stats[b]+ivs[i]+(evs[i]/4))*level[l])/100)+5)

func get_level():
    var l = 0
    for x in level:
        l+=level[x]
    return l/4

func change_hp(d:int):
    hp=clamp(hp+d,0,get_stat(stats.HP))
    
func change_energy(d:int):
    energy=clamp(energy+d,0,get_stat(stats.Energy))
    

    
func take_damage(d:int):
    change_hp(d*-1)

func heal(d:int):
    change_hp(d)   
    
func add_buff(b:Buff):
    if b is StatStages:
        for buff in buffs:
            if buff is StatStages and b.stat==buff.stat:
                b.stages=clamp(b.stages+buff.stages,-6,6)
                return true
    if b is PoisonDebuff:
        for buff in buffs:
            if buff is PoisonDebuff:
                buff.stage=2
                return true
    var _buff=b.duplicate()
    _buff.init(self)
    buffs.append(_buff)
    
func remove_buff(b:Buff):
    if b.has_method("on_removal"):
        b.on_removal()
    for x in range(buffs.size()-1,-1,-1):
        buffs.erase(b)
        
func skill_name_converter(stat:Entity.stats):
    match stat:
        stats.Farm:
            return "farm"
        stats.Mine:
            return "mine"
        stats.Forage:
            return "forage"
        stats.Craft:
            return "craft"
        stats.Cook:
            return 'cook'
        stats.Fishing:
            return 'fishing'
        stats.Perform:
            return 'perform'
        stats.Battle:
            return "battle"

func get_next_exp_level(s:String):
    level_to_next[s]=level[s]*20
    exp[s]=0

static func get_type_color(t:types):
    match t:
        types.Normal: return  Color("#c8cdc9")
        types.Fire:return Color("#e22b00")
        types.Water:return Color("#2778eb")
        types.Grass:return Color("#3b9800")
        types.Electric:return Color("#ffff00")
        types.Ground:return Color("#a88400")
        types.Bug:return Color("#8eaf4f")
        types.Rock:return Color("#796850")
        types.Ice:return Color("#7fdaeb")
        types.Fighting:return Color("#92492b")
        types.Psychic:return Color("#824587")
        types.Dragon:return Color("#004587")
        types.Dark:return Color("#36333a")
        types.Steel:return Color("#847d8a")
        types.Fairy:return Color("#db8ac3")
        types.Poison:return Color("#b301f6")
        types.Flying:return Color("#4b91c1")
        types.Ghost:return Color("#5f4c67")

func do_proportional_damage(d:float):
    var damage = get_stat(stats.HP)*d
    change_hp(-damage)

func get_exp(kind:String,amount:int):
    exp[kind]+=amount
    if exp[kind]>=level_to_next[kind]:
        level[kind]+=1
        exp[kind]=0
        get_next_exp_level(kind)
        var strng = nickname+"'s "+kind+" level is now "+str(level[kind])+"\n"+nickname+" is now level "+str(get_level())
        Signals.send_notice.emit()
                
