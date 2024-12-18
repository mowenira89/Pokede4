class_name ImmunityHidden extends Ability

@export var hidden_immunity:Array[Entity.hidden_statuses]

func check_hidden_immunity(status:Entity.hidden_statuses)->bool:
    if !hidden_immunity.is_empty():
         if status in hidden_immunity:
            Signals.add_message.emit(owner.nickname +" is immune due to "+ability_name+"!")
            return false
    return true
