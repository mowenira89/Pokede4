class_name Paralysis extends Buff

var stat = Entity.stats.Speed

func affect_stat(amount:int):
    return amount+(amount*-.5)

func check_can_attack():
    if randi()%101 > 50: 
        Signals.add_message.emit(owner.nickname+" is paralyzed!")
        return false
    else: return true
