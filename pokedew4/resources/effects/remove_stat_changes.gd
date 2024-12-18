class_name RemoveStatChanges extends Effect

func apply(user,target,move=null,item=null):
    var size = user.buffs.size()
    for x in range(size-1,-1,-1):
        if user.buffs[x] is StatStages:
            user.remove_buff(user.buffs[x])
            
    var size2 = target.buffs.size()
    for x in range(size-1,-1,-1):
        if target.buffs[x] is StatStages:
            target.remove_buff(target.buffs[x])
