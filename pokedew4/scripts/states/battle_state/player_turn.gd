class_name SelectionState extends StateBattle

@onready var battle: BattleUI = $"../.."

@onready var fight: Button = $"../../ColorRect/OptionsContainer/MarginContainer/GridContainer/Fight"
@onready var pkmn: Button = $"../../ColorRect/OptionsContainer/MarginContainer/GridContainer/PKMN"
@onready var bag: Button = $"../../ColorRect/OptionsContainer/MarginContainer/GridContainer/Bag"
@onready var run: Button = $"../../ColorRect/OptionsContainer/MarginContainer/GridContainer/Run"
@onready var end_battle: EndBattleState = $"../EndBattle"

@onready var pkmn_menu: PokemonMenu = $"../../PKMNMenu"
@onready var inv_screen: InvScreen = $"../../InvScreen"


@onready var message: Message = $"../../Message"
@onready var fight_buttons: GridContainer = $"../../ColorRect/FightContainer/MarginContainer/GridContainer"

@onready var fight_container: ColorRect = $"../../ColorRect/FightContainer"
@onready var enemy_turn: EnemyTurn = $"../EnemyTurn"
@onready var player_turn: PlayerTurn = $"../PlayerTurn"
var menuing:bool=false

enum substates {NORMAL,FIGHT}
var substate:substates=substates.NORMAL

var main_button_coord:Vector2=Vector2(0,0)
var button_coord_dict = {}

var focused_element:Control=null

var selections = {
    Vector2(0,0):fight_pressed,
    Vector2(1,0):bag_pressed,
    Vector2(0,1):pkmn_pressed,
    Vector2(1,1):run_pressed
}
func init():
    pass
    
func enter():
    inv_screen.unmenu.connect(func():menuing=false)
    pkmn_menu.unmenu.connect(func():menuing=false)
    var pp = state_machine.player_pokemon
    
    
    for x in pp.buffs:
        if x is FlinchBuff:
            state_machine.change_state(enemy_turn)
            return
    
    for x in pp.buffs:
        var m = x.next_turn_attack()
        if m is Move:
            state_machine.next_player_move=m
            determine_order()
            return            
    
    
    main_button_coord = Vector2(0,0)
    
    Signals.toggle_substate.connect(switch_substate)
    get_viewport().connect("gui_focus_changed",_on_focus_changed)
    button_coord_dict = {
    Vector2(0,0):fight,
    Vector2(1,0):bag,
    Vector2(0,1):pkmn,
    Vector2(1,1):run
    }
    change_focused_button(0,0)
    var pb = state_machine.player_pokemon.buffs
    for x in range(pb.size()-1,-1,-1):
        if pb[x].has_method('charged attack'):
            state_machine.next_player_move=pb[x].move
            pb[x].activate()
            determine_order()
 
func exit():
    inv_screen.unmenu.disconnect(func():menuing=false)
    Signals.toggle_substate.disconnect(switch_substate)
    pkmn_menu.unmenu.disconnect(func():menuing=false)
    get_viewport().disconnect("gui_focus_changed", _on_focus_changed)
    
func process(delta)->StateBattle:
    return null
    
func physics(delta)->StateBattle:
    return null

func handle_input(event)->StateBattle:
    if !menuing:
        if event.is_action_pressed("up"):
            change_focused_button(-1,0)
        if event.is_action_pressed("down"):
            change_focused_button(1,0)
        if event.is_action_pressed("right"):
            change_focused_button(0,1)
        if event.is_action_pressed("left"):
            change_focused_button(0,-1)
        if event.is_action_pressed('accept'):
            if message.visible:
                Signals.display_messages.emit()
            else:
                if substate==substates.NORMAL:
                    selections[main_button_coord].call()
                elif substate==substates.FIGHT:
                    if focused_element in fight_buttons.get_children():
                        move_selected()
        if event.is_action_pressed('cancel') and substate==substates.FIGHT:
            fight_unpressed()
            
    return null

func change_focused_button(x,y):
    main_button_coord.x+=x
    main_button_coord.y+=y
    if button_coord_dict.has(main_button_coord):
        button_coord_dict[main_button_coord].grab_focus()
    else:   
        if main_button_coord.y==2:main_button_coord.y=0
        elif main_button_coord.x==2:main_button_coord.x=0
        elif main_button_coord.y==-1:main_button_coord.y=1
        elif main_button_coord.x==-1:main_button_coord.x=1
        button_coord_dict[main_button_coord].grab_focus()
    
func switch_substate(s:String):
    match s:
        'normal':
            substate=substates.NORMAL
            button_coord_dict = {
                Vector2(0,0):fight,
                Vector2(1,0):bag,
                Vector2(0,1):pkmn,
                Vector2(1,1):run
            }
            selections = {
            Vector2(0,0):fight_pressed,
            Vector2(1,0):bag_pressed,
            Vector2(0,1):pkmn_pressed,
            Vector2(1,1):run_pressed
            }
        'fight':
            substate=substates.FIGHT
            button_coord_dict = {
                Vector2(0,0):fight_buttons.get_child(0),
                Vector2(1,0):fight_buttons.get_child(2),
                Vector2(0,1):fight_buttons.get_child(1),
                Vector2(1,1):fight_buttons.get_child(3)
            }
            change_focused_button(0,0)


func fight_pressed():
    switch_substate("fight")
    fight_container.visible=true
    set_fight_buttons()
    

func fight_unpressed():
    switch_substate('normal')
    fight_container.visible=false

func pkmn_pressed():
    pkmn_menu.visible=true
    menuing=true

func bag_pressed():
    inv_screen.visible=true
    menuing=true
    
func run_pressed():
    state_machine.change_state(end_battle)

func _on_focus_changed(control:Control):
    focused_element=control

func move_selected():
    for x in range(0,4):
        if fight_buttons.get_children()[x] == focused_element:
            if focused_element.text!="":
                var user=state_machine.player_pokemon
                var move = user.current_moves[x]
                state_machine.move_moves(move)
                determine_order()                
                fight_unpressed()

func set_fight_buttons():
    if state_machine.player_pokemon is Pokemon:
        var moves = state_machine.player_pokemon.current_moves
        moves.resize(4)
        for x in range(0,4):
            if moves[x]==null:
                fight_buttons.get_child(x).text=""
            else:
                fight_buttons.get_child(x).text=moves[x]._name
        

func determine_order():
    state_machine.next_opponent_attack = select_enemy_move()
    if state_machine.next_opponent_attack.priority>state_machine.next_player_move.priority:
        state_machine.turns = [enemy_turn,player_turn]
    if state_machine.next_opponent_attack.priority<state_machine.next_player_move.priority:
        state_machine.turns = [player_turn,enemy_turn]
    if state_machine.next_opponent_attack.priority==state_machine.next_player_move.priority:
        state_machine.turns = [player_turn,enemy_turn] if state_machine.opponent_pokemon.get_stat(Entity.stats.Speed) <= state_machine.player_pokemon.get_stat(Entity.stats.Speed) else [enemy_turn,player_turn]
    state_machine.change_state(state_machine.turns[0])  

func select_enemy_move():
    for x in state_machine.opponent_pokemon.buffs:
        if x.has_method('charging_attack'):
            return x.move 
    return state_machine.opponent_pokemon.current_moves.pick_random()
