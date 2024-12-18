class_name PokeballEffect extends Effect

@export var catch_rate:int

func apply(user,target,move=null,item=null):
    if target is Pokemon:
        var status=1
        var ball_multiplier=1
        var rate = target.capture_rate
        
        #insert logic for apricorn balls here
        
        var max_hp = target.get_stat(Entity.stats.HP)
        var current_hp = target.hp
        
        var catch_rate = ((3*(max_hp))-(2*current_hp))/(3*max_hp)
        if randi()%255<catch_rate:
            Signals.switch_battle_state.emit("caught")
