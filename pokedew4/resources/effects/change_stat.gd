class_name ChangeStatEffect extends Effect

enum stats {HP,ENERGY,HAPPINESS}
@export var stat:stats
@export var amount:int


func apply(user,target,move=null,item=null):
    if target is Pokemon:
        match stat:
            stats.HP:
                target.change_hp(amount)
            stats.ENERGY:
                target.change_energy(amount)
            stats.HAPPINESS:
                target.change_happiness(amount)
