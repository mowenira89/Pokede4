class_name HealEffect extends Effect

@export var amount:int

func apply(user,target,move=null,item=null):
    if target is Entity:
        target.heal(amount)
        return true
