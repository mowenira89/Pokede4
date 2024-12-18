class_name ChargeAttackBuff extends Buff

@export var move:Move
@export var s:String

func init(o):
    super(o)
    Signals.add_message.emit(o.nickname +" "+ s)

func next_turn_attack():
    Signals.change_next_attack.emit(move)
    owner.remove_buff(self)

#intentionally left blank
func charged_attack():
    pass
