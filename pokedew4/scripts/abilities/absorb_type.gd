class_name AbsorbType extends Ability

@export var type:Entity.types

func hit_by_type(t:Entity.types,damage):
    if t==type:
        owner.heal(damage)
        Signals.add_message.emit(owner.nickname+"'s health was restored with "+ability_name+"!")
        return false
    else: 
        return true
