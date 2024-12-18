class_name Confusion extends Buff

var turns:int=0

func init(o):
    super(o)
    turns=randi_range(2,8)

func check_can_attack():
    turns-=1
    if turns<=0:
        Signals.add_message.emit(owner.nickname+" snapped out of confusion!")
        owner.remove_buff(self)
        return true
    if randi()%101<50:
        var hp = owner.get_stat(Entity.stats.HP)
        owner.take_damage(hp*.0125)
        Signals.add_message.emit(owner.nickname+" hurt itself in its confusion!")
        
