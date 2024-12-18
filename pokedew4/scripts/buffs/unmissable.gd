class_name UnmissableBuff extends Buff
#applied to the opponent with mind reader, etc

func on_switch_out():
    owner.remove_buff(self)
