class_name Immunity extends Ability


@export var immunity:Array[Entity.main_status]

func check_immunity(status:Entity.main_status)->bool:
    if !immunity.is_empty():
         if status in immunity:
            Signals.add_message.emit(owner.nickname +" is immune due to "+ability_name+"!")
            return false
    return true
