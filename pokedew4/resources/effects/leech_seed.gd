class_name LeechSeedEffect extends Effect



func apply(user,target,move=null,item=null):
    if Entity.types.Grass in target.data.type:
        Signals.add_message.emit(target.nickname + " is unaffected")
        return
    var buff = LeechSeedDebuff.new()
    buff.init(user)
    target.apply_buff(buff)
    Signals.add_message.emit(target.nickname + " was seeded!")   
