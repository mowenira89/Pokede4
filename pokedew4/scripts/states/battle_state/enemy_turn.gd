class_name EnemyTurn extends StateBattle

@onready var selection_state: SelectionState = $"../SelectionState"
@onready var player_turn: PlayerTurn = $"../PlayerTurn"
@onready var message: Message = $"../../Message"

@onready var end_battle: EndBattleState = $"../EndBattle"


func init():
    pass
    
func enter():
    var pp = state_machine.opponent_pokemon
    var op = state_machine.player_pokemon
    
    Signals.change_next_attack.connect(switch_attack)
    
    #CHECK NEXT TURN EFFECTS
    for x in pp.buffs:
        var m = x.next_turn_attack()
        if m is Move:
            state_machine.next_opponent_attack=m
            
            
    var move = state_machine.next_opponent_attack
    
    if move==null:
        move=pp.current_moves.pick_random()
    Signals.add_message.emit("Opponent " + pp.nickname + " used " + move._name + "!")
    
    if pp.energy<=0:
        Signals.add_message.emit(pp.nickname+" is out of energy!")
        next_turn()
        return
    
    if move.targ==Move.targets.Self:
        move.use(pp,pp)
    else:
        if state_machine.accuracy_check(pp,op,move):
            move.use(pp,op)
            if move.contact: 
                pp.ability.on_contact(pp,op,move)
                op.ability.on_contact(op,pp,move)
            var faint = await state_machine.faint_check()
            if !faint: 
                state_machine.change_state(end_battle)
                return
    
    for x in range(pp.buffs.size()-1,-1,-1):
        pp.buffs[x].on_turn_end()
        
    var faint = await state_machine.faint_check()
    if !faint: 
        state_machine.change_state(end_battle)
        return
        
    Signals.display_messages.emit()
    await Signals.messages_done
    next_turn()
    
    
func next_turn():
    if state_machine.turns[0] is EnemyTurn:
        state_machine.change_state(player_turn)
    else:
        state_machine.change_state(selection_state)    
        
    
func exit():
    Signals.change_next_attack.disconnect(switch_attack)
    
func process(delta)->StateBattle:
    return null
    
func physics(delta)->StateBattle:
    return null

func handle_input(event)->StateBattle:
    if event.is_action_pressed('accept') or event.is_action_pressed('cancel'):
        if message.visible:
            message.next_message()
    return null

func switch_attack(m:Move):
    state_machine.next_opponent_attack=m
