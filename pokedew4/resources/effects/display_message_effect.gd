class_name DisplayMessageEffect extends Effect

@export var s:String

@export var oak:bool

func apply(user, target,move=null,item=null):
    if oak:s="O.A.K: It isn't the right time to use that!"
    Signals.add_message.emit(user.data.name+" "+s)
