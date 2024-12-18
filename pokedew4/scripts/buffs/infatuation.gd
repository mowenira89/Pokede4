class_name Infatuation extends Buff

var object_of_infatuation:Entity

var turns:int

func init(o):
    super(o)
    turns = randi_range(2,8)

func check_can_attack():
    turns-=1
    if turns==0:
        owner.remove_buff(self)
        Signals.add_message.emit(owner.nickname + " is no longer infatuated!")
        return true
    else:
        if randi()%101<80:
            Signals.add_message.emit(owner.nickname + "is infatuated with the opponent!")
            return false
        else:
            return true
            
func on_switch_out():
    owner.remove_buff(self)
