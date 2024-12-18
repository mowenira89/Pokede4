class_name ChangeStat extends Buff

@export var stat:Entity.stats
@export var factor:float

func affect_stat(amount:int):
    return amount+(amount*factor)
    
func create_buff(s:Entity.stats,f:float,p:bool,l:bool):
    stat=s
    factor = f
    permanent = p
    lost_on_switch_out = l
