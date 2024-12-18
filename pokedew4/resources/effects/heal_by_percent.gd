class_name HealPercent extends Effect

@export var percentage:float

func apply(user,target,move=null,item=null):
    var hp =target.get_stat(Entity.stats.HP)
    var hp_increase = hp*percentage
    target.hp+=clamp(target.hp+hp_increase,0,hp)
    Signals.add_message.emit(target.nickname+" was healed!")
