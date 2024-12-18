class_name HealAllStatus extends Effect

func apply(user,target,move=null,item=null):
    if target is Pokemon:
        target.status=null
        for x in range(target.buffs.size()-1,-1,-1):
            if target.buffs[x] in [Unfreeze,Confusion]:
                target.buffs.erase(x)
