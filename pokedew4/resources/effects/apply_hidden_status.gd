class_name ApplyHiddenStatus extends Effect

@export var chance:int
@export var status:Entity.hidden_statuses



func apply(owner,target,move=null,item=null):
    
    if target.ability.check_hidden_immunity(status)==false:
        return false
    if randi()%101<=chance:
        match status:
            Entity.hidden_statuses.Confusion:
                for x in target.buffs:
                    if x is Confusion: 
                        return
                var b = Confusion.new()
                target.add_buff(b)
        
        
