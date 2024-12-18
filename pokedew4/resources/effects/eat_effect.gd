class_name EatEffect extends Effect

@export var buff:Buff

@export var health_restored:int
@export var energy_restored:int
@export var happiness_bonus:int

func apply(user,target,move=null,item=null):
    if target is Pokemon:
        for x in item.data.flavor:
            target.taste(item.data.flavor,item.data.flavor_profile,happiness_bonus)
        target.heal(health_restored)
        target.change_energy(energy_restored)
        return true
    elif item.data is not Berry and target is Player:
        target.data.heal(health_restored)
        target.data.change_energy(energy_restored)
    else: return false
    
    
