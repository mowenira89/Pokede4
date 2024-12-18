class_name FlinchBuff extends Buff

func init(o):
    super(o)
    

func check_can_attack():
    Signals.add_message.emit(owner.nickname + " flinched!")
    return false
    
func on_turn_end():
    owner.remove_buff(self)
