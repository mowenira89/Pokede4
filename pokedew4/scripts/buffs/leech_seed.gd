class_name LeechSeedDebuff extends Buff



func on_turn_end():
    var damage = owner.get_stat(Entity.stats.HP)*(1/16)
    owner.take_damage(damage)
    
    Signals.heal_opponent.emit(owner, damage)
    
    
