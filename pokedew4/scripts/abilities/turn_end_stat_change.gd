class_name TurnEndStatChange extends Ability

@export var buff:StatStages

func on_end_turn():
    owner.add_buff(buff)
