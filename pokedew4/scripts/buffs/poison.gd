class_name PoisonDebuff extends Buff

@export var stage:int=1

func on_turn_end():
    owner.take_damage(owner.get_stat(Entity.stats.HP)*(1/(16/stage)))
    Signals.add_message.emit(owner.nickname +" was hurt by poison!")
