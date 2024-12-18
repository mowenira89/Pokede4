class_name BattleStateMachine extends Node

var states=[]
var prev_state:StateBattle
var current_state:StateBattle

var player_pokemon:Entity
var opponent_pokemon:Entity
var turns = []
var last_player_move:Move
var last_opponent_move:Move
var next_opponent_attack:Move
var next_player_move:Move
@onready var pkmn_menu: PokemonMenu = $"../PKMNMenu"
@onready var battle_start: BattleStart = $BattleStart
@onready var enemy_turn: EnemyTurn = $EnemyTurn
@onready var selection_state: SelectionState = $SelectionState
@onready var player_sprite: Sprite2D = $"../TextureRect/PlayerSprite"
@onready var enemy_sprite: Sprite2D = $"../TextureRect/EnemySprite"
@onready var end_battle: Node = $EndBattle
@onready var pkmn_screen: PkmnScreenBattleState = $PkmnScreen

var was_in_battle=[]

func _ready():
    process_mode=Node.PROCESS_MODE_DISABLED
    pkmn_menu.send_out_pokemon.connect(switch_in_player_pokemon)
    Signals.switch_in_opponent.connect(switch_in_opponent_pokemon)
    Signals.switch_battle_state.connect(switch_battle_state)
    Signals.heal_opponent.connect(heal_opponent)
    initialize()
    
func initialize():	
    for c in get_children():
        if c is StateBattle: states.append(c)
    if states.size()>0:
        for x in states:
            x.state_machine=self
            x.init()
        change_state(states[0])
        process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta):
    change_state(current_state.process(delta))
    
func _physics_process(delta):
    change_state(current_state.physics(delta))
    
func _unhandled_input(event):
    change_state(current_state.handle_input(event))
    
func change_state(new_state:StateBattle):
    if new_state==null or new_state==current_state:return
    if current_state: current_state.exit()
    prev_state=current_state
    current_state=new_state
    current_state.enter()

func switch_in_player_pokemon(p:Entity):
    if player_pokemon!=null:
        for x in player_pokemon.buffs:
            if x.has_method("prevent_switch_out"):
                x.prevent_switch_out()
                return
        player_pokemon.switch_out()
    player_pokemon = p
    Refs.currently_battling=p
    player_sprite.texture = player_pokemon.image
    if p not in was_in_battle: was_in_battle.append(p)
    if current_state is SelectionState:
        change_state(enemy_turn)
    else:
        change_state(selection_state)
    
func switch_in_opponent_pokemon(p:Entity):
    opponent_pokemon = p
    get_parent().enemy_sprite.flip_h=true
    get_parent().enemy_sprite.texture = opponent_pokemon.image
    Signals.add_message.emit("A wild "+opponent_pokemon.nickname+" appeared!!!!")
    Signals.display_messages.emit()


func switch_battle_state(s:String):
    match s:
        "selection": change_state(selection_state)

func faint_check()->bool:
    if opponent_pokemon.hp<=0:
        opponent_pokemon.status=Entity.main_status.FNT
        Signals.add_message.emit(opponent_pokemon.nickname+" fainted!")
        change_state(end_battle)
        return false
    if player_pokemon.hp<=0:
        player_pokemon.status=Entity.main_status.FNT
        Signals.add_message.emit(player_pokemon.nickname+" fainted!")
        Signals.display_messages.emit()
        await Signals.messages_done
        if Refs.check_remaining()>0:
            change_state(pkmn_screen)
            Signals.toggle_substate.emit('forced_select')
        else:
            change_state(end_battle)
        return false
    return true

static func accuracy_check(user:Entity,target:Entity,move:Move):
    for x in target.buffs:
        if x is UnmissableBuff:
            return true
    
    if Entity.hidden_statuses.Underground in target.hidden_status and move.type!=Pokemon.types.Ground:
        Signals.add_message.emit(target.nickname + " avoided the attack!")
        return false
        
    if Entity.hidden_statuses.Flying in target.hidden_status and move.type!=Pokemon.types.Electric and move.move_type==1:
        Signals.add_message.emit(target.nickname + " avoided the attack!")
        return false
        
    if move.unmissable: return true
    var mod_acc = move.acc
    if user.ability is CompoundEyes:mod_acc*=1.3
    var acc = (user.get_stat(Entity.stats.Accuracy)-target.get_stat(Entity.stats.Evasion))+mod_acc
    var r = randi()%100
    if r<acc:
        return true
    else:
        Signals.add_message.emit("But it missed!!")
        return false
    
func move_moves(m:Move):
    last_player_move=next_player_move
    last_opponent_move=next_opponent_attack
    next_player_move=m

func heal_opponent(user,damage):
    if user == opponent_pokemon:
        player_pokemon.heal(damage)
        Signals.add_message.emit(player_pokemon.nickname+" was healed by leech seed!")
    else:
        opponent_pokemon.heal(damage)
        Signals.add_message.emit(opponent_pokemon.nickname+" was healed by leech seed!")
