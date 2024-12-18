class_name Buff extends Resource

@export var permanent:bool
@export var lost_on_switch_out:bool
var owner:Entity

func init(o:Entity):
    owner = o

func erase():
    owner.buffs.erase(self)

func apply():
    pass


func on_turn_end():
    pass

func on_switch_out():
    pass

func battle_over():
    pass

#checks if the pokemon has charged an attack
func next_turn_attack():
    pass
    
#for x in buffs if check can attack false entity cannot attack
func check_can_attack():
    return true
