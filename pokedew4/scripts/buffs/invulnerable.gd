class_name Invulnerable extends Buff

@export var status:Entity.hidden_statuses

func check_can_attack():
    owner.hidden_status.erase(status)
    owner.remove_buff(self)
    return true
