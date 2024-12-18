class_name Burn extends Buff

var stat = Entity.stats.Attk

func on_turn_end():
    owner.take_damage(owner.get_stat(Entity.stats.HP)*(1/16))

func affect_stat(amount:int):
    return amount-(amount*.33)
    
