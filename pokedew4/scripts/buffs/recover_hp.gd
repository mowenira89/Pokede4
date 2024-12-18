class_name RecoverHP extends Buff

@export var factor:float

func on_turn_end():
    var r = owner.get_stat(Entity.stats.HP)*factor
    owner.heal(r)
