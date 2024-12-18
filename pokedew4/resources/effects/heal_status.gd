class_name HealMainStatus extends Effect

@export var status:Entity.main_status

func apply(user,target,move=null,item=null):
    if user.status==status:
        user.status=null
