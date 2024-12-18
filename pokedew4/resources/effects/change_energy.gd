class_name ChangeEnergyEffect extends Effect

@export var amount:int

func apply(user,target,move=null,item=null):
    target.change_energy(amount)
