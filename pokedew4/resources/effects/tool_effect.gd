class_name ToolEffect extends Effect

enum tool_types {AXE,PICKAXE,HOE,WATERING_CAN,SHEARS,SHOVEL}

@export var tool_type:tool_types
@export var tool_level:int
@export var damage:int


func apply(user,target,move=null,item=null):
    if target is Vector2:
        if target in Refs.current_level.obstructions:
            var o = Refs.current_level.obstructions
            if o[target] is Breakable or o[target] is _Tree:
                for x in o[target].data.tool_type:
                    if x == tool_type:
                        o[target].get_broken(damage)

            
