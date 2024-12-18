class_name ThiefEffect extends Effect

func apply(user,target,move=null,item=null):
    if target.held_item!=null:
        if InvManager.add(target.held_item):
            Signals.add_message.emit(user.nickname+" stole the opponent "+target.nickname+"'s "+target.held_item.data.item_name)
        else:
            Signals.add_message.emit("The opponent "+target.nickname+"'s "+target.held_item.data.item_name+" fell off!")            
        target.held_item=null
