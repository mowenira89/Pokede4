class_name MoveBuffManager extends Node

@export var dict:Dictionary 

var applied_buffs:Dictionary={}

func apply(id:String):
    if dict[id] is PassiveBuff:
        if id not in applied_buffs:
            var nn = Node.new()
            add_child(nn)
            nn.set_script(dict[id])
            applied_buffs[id]=nn
        
func remove(id:String):
    applied_buffs[id].queue_free()
    applied_buffs.erase(id)
