class_name BindTypeAttack extends Buff
#for moves that hit multiple turns like bind. applied to the injured entity.

@export var min_turns:int
@export var max_turns:int
@export var d_factor:int
var turns
@export var move_name:String
@export var cant_attack:bool
func init(o):
    super(o)
    turns = randi_range(min_turns,max_turns+1)
    
func prevent_switch_out():
    Signals.add_message.emit(owner.nickname + " is trapped by " +move_name)

func check_can_attack():
    if cant_attack:
        Signals.add_message.emit(owner.nickname + " is trapped by " +move_name)
        return false

func on_turn_end():
    owner.take_damage(owner.get_stat(Entity.stats.HP)*d_factor)
    Signals.add_message.emit(owner.nickname + " was hurt by "+move_name)
    turns-=1
    if turns<=0:
        owner.remove_buff(self)
