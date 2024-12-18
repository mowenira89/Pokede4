class_name ApplyMainStatus extends Effect

@export var chance:int
@export var status:Entity.main_status


func apply(user:Entity,target:Entity,move=null,item=null):
    if move._name=="Rest":
        target.heal_full()
        w("fell asleep!",target)
        var p = Unfreeze.new()
        target.add_buff(p)
        target.status=status
        return
        
    var can_apply = target.ability.check_immunity(status)
    if !can_apply: 
        return false
    
    if randi()%101<chance:
            target.status=status         
            match status:
                Entity.main_status.PSN:
                    w("was poisoned!",target)
                    var p = PoisonDebuff.new()
                    target.add_buff(p)
                Entity.main_status.PRLZ:
                    w("was paralyzed!",target)
                    var p = Paralysis.new()
                    target.add_buff(p)
                Entity.main_status.SLP:
                    w("fell asleep!",target)
                    var p = Unfreeze.new()
                    target.add_buff(p)
                Entity.main_status.FRZ:
                    w("was frozen solid!",target)
                    var p = Unfreeze.new()
                    target.add_buff(p)
                Entity.main_status.BRN:
                    w("was burned!",target)
                    var p = Burn.new()
                    target.add_buff(p)
                
                    
func w(s:String,t:Entity):
    Signals.add_message.emit(t.nickname+" "+s)
