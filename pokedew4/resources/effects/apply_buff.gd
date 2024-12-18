class_name ApplyBuff extends Effect

enum targets {Target,User}

@export var buff:Buff
@export var chance = 100
@export var targ:targets

func apply(user,target,move=null,item=null):
    if randi()%101<chance:
        if targ==0:
            target.add_buff(buff.duplicate())
        else:
            user.add_buff(buff.duplicate())            
