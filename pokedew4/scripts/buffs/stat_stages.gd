class_name StatStages extends Buff

@export var stage:int
@export var stat:Entity.stats

func affect_stat(amount:int):
    var a = amount
    a+=a*((stage*10)/100)
    
    return a
    

func on_switch_out():
    owner.buffs.erase(self)
