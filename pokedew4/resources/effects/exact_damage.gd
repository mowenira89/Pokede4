class_name ExactDamage extends Effect

@export var damage:int

@export var by_level:bool

@export var ohko:bool

func apply(user,target,move=null,item=null):
    if damage>0:
        target.take_damage(damage)
    elif by_level:
        target.take_damage(target.get_level())
    elif ohko:
        target.take_damage(target.get_stat(Entity.stats.HP))
