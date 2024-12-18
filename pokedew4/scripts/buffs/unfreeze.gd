class_name Unfreeze extends Buff

var turns:int

func init(owner:Entity):
    super(owner)
    turns = randi_range(2,7)
    
func check_can_attack():
    turns-=1
    if turns<=0:
        var message=""
        match owner.status:
            Entity.main_status.FRZ:
                Signals.add_message.emit(owner.nickname+" thawed out!")
            Entity.main_status.SLP:
                Signals.add_message.emit(owner.nickname+" woke up!")    
        owner.status=null
        owner.remove_buff(self)
        return true
    return false
