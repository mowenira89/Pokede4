class_name Leftovers extends Buff

func on_turn_end():
    owner.heal(owner.get_stat(Entity.stats.HP)*.0125)
