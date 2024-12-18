class_name RemoveStatusEffect extends Effect

@export var buff:String

func apply(user,target,move=null,item=null):
    if target is Pokemon:
        for x in target.buffs:
            if x.id==buff:
                target.buffs.erase(x)
             
