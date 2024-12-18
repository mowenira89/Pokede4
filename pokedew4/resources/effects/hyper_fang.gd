class_name HyperFangEffect extends Effect

@export var percentage:float

func apply(user,target,move=null,item=null):
    target.take_damage(target.hp*percentage)
