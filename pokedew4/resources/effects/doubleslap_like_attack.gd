class_name MultiHitAttack extends Effect
#used for moves like double slap
@export var min_hits:int
@export var max_hits:int

@export var damage:Effect

func apply(user:Entity,target:Entity,move=null,item=null):
    var r = randi_range(min_hits,max_hits+1)
    var total=0    
    for x in r:
        
        var mod_acc = move.acc
        if user.ability is CompoundEyes:mod_acc*=1.3
        var acc = (user.get_stat(Entity.stats.Accuracy)-target.get_stat(Entity.stats.Evasion))+mod_acc
        var rando = randi()%101
        if rando<acc:
            damage.apply(user,target)
            total+=1
            
    Signals.add_message.emit("It hit "+str(total)+"times!")
        
