class_name ProportionateDamage extends Effect

@export var rate:float

func apply(user,target,move=null,item=null):
    target.take_damage(target.get_stat(Entity.stats.HP)*rate)
