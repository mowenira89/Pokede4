class_name RechargeBuff extends Buff

@export var string:String

func check_can_attack():
    Signals.add_message.emit(owner.nickname+" "+string)
    return false

func on_turn_end():
    owner.remove_buff(self)
