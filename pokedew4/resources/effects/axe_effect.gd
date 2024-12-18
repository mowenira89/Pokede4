class_name AxeEffect extends Effect

@export var damage:int
@export var axe_level:int

func apply(user,target,move=null,item=null):
    if target is Player:
        var c = target.get_cursor_position()
        if c in Refs.current_level.obstructions and Refs.current_level.obstructions[c].has_method("get_chopped"):
            Refs.current_level.obstructions[c].get_chopped(axe_level,damage)            
