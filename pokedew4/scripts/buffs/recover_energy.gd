class_name RecoverEnergy extends Buff


@export var factor:float

func on_turn_end():
    var r = owner.get_stat(Entity.stats.Energy)*factor
    owner.change_energy(r)
