class_name SixteenthDamage extends Effect

func apply(user:Entity,target:Entity,move=null,item=null):
    var damage = target.get_stat(Entity.stats.HP)*(1/16)
