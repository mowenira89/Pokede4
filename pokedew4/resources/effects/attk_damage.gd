class_name AttackDamage extends Effect

@export var high_crit:bool
@export var recoil:float=0
@export var recovered:float=0

func apply(user,target,move=null,item=null):
    var adj_power:int
    var weakness=1
    var resist=1
    for x in target.type:
        if move.type in Entity.type_profile[x]['weakness']:
            weakness*=2
        if move.type in Entity.type_profile[x]['resist']:
            weakness=clamp(weakness-.5,.25,1)
    var a = user.get_stat(Entity.stats.Attk) if move.move_type==0 else user.get_stat(Entity.stats.Sattk)
    var d = user.get_stat(Entity.stats.Sdef) if move.move_type==0 else user.get_stat(Entity.stats.Sdef)
    var STAB:int=1
    var crit:int=1
    if move.type in user.type:
        STAB=1.5
    var r = randi()%101
    var crit_rate = user.get_stat(Entity.stats.CritRate)
    if high_crit:
        crit_rate-=10
    if r>crit_rate:
        crit=2
    if target.ability is BattleArmor: crit=1
    if crit>1:Signals.add_message.emit("Critical hit!")
    if weakness>1:Signals.add_message.emit("It's super effective!")
    if weakness<1:Signals.add_message.emit("It's not very effective...")
        
    if target.ability==AH.abs.BattleArmor:crit=1

    if user.ability==AH.abs.FlashFire and move.type==Pokemon.types.Fire and Pokemon.hidden_statuses.FlashFire in user.hidden_status:
        a+=a*.5
    
    adj_power = move.power
    var weather = Refs.get_weather()
    if user.ability is CloudNine:
        pass
    else:
        if weather==2:
            if move.type==Pokemon.types.Water: adj_power*=1.5
            if move.type==Pokemon.types.Fire: adj_power*=.5
        if weather==1:
            if move.type==Pokemon.types.Water: adj_power*=.5
            if move.type==Pokemon.types.Fire: adj_power*=1.5
    
    var damage = ceil((((((2*user.level['battle']/5)+2)*adj_power*(a/d))/50)+2)*STAB*crit*weakness*resist)
    
    if target.ability is Sturdy and target.hp==target.get_stat(Entity.stats.HP) and target.hp-damage<=0:
        target.hp=1
        damage=0
        Signals.add_message.emit(target.nickname+" hung on with Sturdy!")
    
    if target.ability is AbsorbType:
        if move.contact:
            var can_proceed = target.ability.hit_by_type(move.type,damage)
            if !can_proceed:
               return             
            
    elif target.ability is FlashFire and move.type==Pokemon.types.Fire:
        Signals.add_message.emit(target.nickname+" negated the damage with FlashFire!")
        if Pokemon.hidden_statuses.FlashFire not in target.hidden_status: target.hidden_status.append(Pokemon.hidden_statuses.FlashFire)
    else:      
        target.take_damage(damage)

    if recoil>0:
        user.take_damage(damage*recoil) 
        Signals.add_message.emit(user.nickname+" was damaged by recoil!")

    if recovered>0:
        user.heal(clamp(damage*recovered,1,damage*recovered))
        target.change_energy(-(damage*recovered))
        user.change_energy(damage*recovered)
