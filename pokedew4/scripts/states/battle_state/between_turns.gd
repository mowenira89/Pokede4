class_name PlayerTurn extends StateBattle
@onready var player_turn: PlayerTurn = $"../PlayerTurn"
@onready var enemy_turn: EnemyTurn = $"../EnemyTurn"
@onready var selection_state: SelectionState = $"../SelectionState"
@onready var message: Message = $"../../Message"

@onready var ability_manager: Node = $"../../AbilityManager"

var next_state:StateBattle = null

func init():
    pass
    
func enter():
    Signals.change_next_attack.connect(switch_attack)
    
    var pp = state_machine.player_pokemon
    var op = state_machine.opponent_pokemon
    
    var can_attack = []
    for x in pp.buffs:
        can_attack.append(x.check_can_attack())
    for x in can_attack:
        if x==false:
            Signals.display_messages.emit()
            next_turn()
            return
    #check next turn effect
    for x in pp.buffs:
        var m = x.next_turn_attack()
        if m is Move:
            state_machine.next_player_move=m
        
    var move = state_machine.next_player_move
    
    
    Signals.add_message.emit(pp.nickname + " used " + move._name+"!")
    var move_used=false
    if move.targ==Move.targets.Self:
        move.use(pp,pp)
        move_used=true
    else:    
        if state_machine.accuracy_check(pp,op,move):
            move.use(pp,op)
            move_used=true
            
    if move_used:
        ability_manager.on_attack(pp,op,move)
    if move_used and move.contact: 
        pp.ability.on_contact(pp,op,move)
        op.ability.on_contact(op,pp,move)
        
        
    var faint = await state_machine.faint_check()
    if !faint:
        return
    for x in range(pp.buffs.size()-1,-1,-1):
        pp.buffs[x].on_turn_end()
    ability_manager.on_turn_end(pp,op,move)
    var faint2 = await state_machine.faint_check()
    if !faint2:
        return
    Signals.display_messages.emit()
    await Signals.messages_done
    next_turn()
    
func next_turn():    
    if state_machine.turns[0] is PlayerTurn:
        state_machine.change_state(enemy_turn)
    else:
        state_machine.change_state(selection_state)

func exit():
    Signals.change_next_attack.disconnect(switch_attack)
    
func process(delta)->StateBattle:
    return next_state
    
func physics(delta)->StateBattle:
    return null

func handle_input(event)->StateBattle:
    if event.is_action_pressed('accept') or event.is_action_pressed('cancel'):
        if message.visible:
            message.next_message()
    return null

func switch_attack(m:Move):
    state_machine.next_player_move=m
