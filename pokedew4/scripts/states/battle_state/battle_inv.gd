class_name InvBattleState extends StateBattle
@onready var player_turn: PlayerTurn = $"../PlayerTurn"
@onready var inv_screen: InvScreen = $"../../InvScreen"
@onready var selection_state: SelectionState = $"../SelectionState"
@onready var message: Message = $"../../Message"


enum substates {NORMAL,OPTIONS,STATS,POKESELECTION}
var substate:substates=substates.NORMAL
func init():
    pass
    
func enter():
    Signals.toggle_substate.connect(toggle_substate)
    inv_screen.visible=true
    
func exit():
    Signals.toggle_substate.disconnect(toggle_substate)
    inv_screen.visible=false
    
func process(delta)->StateBattle:
    return null
    
func physics(delta)->StateBattle:
    return null

func handle_input(event)->StateBattle:
    if message.visible:
        if event.is_action_pressed('accept'):
            Signals.display_messages.emit()
        return
    if substate==substates.NORMAL:
        if event.is_action_pressed('right'):
            inv_screen.set_cursor(inv_screen.selected_index+1)
        if event.is_action_pressed('left'):
            inv_screen.set_cursor(inv_screen.selected_index-1)
        if event.is_action_pressed('down'):
            inv_screen.set_cursor(inv_screen.selected_index+10)
        if event.is_action_pressed('up'):
            inv_screen.set_cursor(inv_screen.selected_index-10)
        if event.is_action_pressed('cancel'):
            inv_screen.close_menu()
            return selection_state
        if event.is_action_pressed('c'):
            inv_screen.set_for_movement() 
        if event.is_action_pressed('accept'):
            inv_screen.show_options()
            substate=substates.OPTIONS
    elif substate==substates.OPTIONS:
        if event.is_action_pressed("cancel"):
            inv_screen.close_options()
            substate=substates.NORMAL
        if event.is_action_pressed('up'):
            inv_screen.move_options(-1)
        if event.is_action_pressed('down'):
            inv_screen.move_options(1)
        if event.is_action_pressed('accept'):
            inv_screen.select_option()
    elif substate==substates.POKESELECTION:
        if event.is_action_pressed('down'):
            inv_screen.move_panel_selection(1)
        if event.is_action_pressed('up'):
            inv_screen.move_panel_selection(-1)
        if event.is_action_pressed('cancel'):
            inv_screen.close_panels()
            substate=substates.OPTIONS
        if event.is_action_pressed('accept'):
            inv_screen.select_mon()
    return null

func toggle_substate(s:String):
    match s:
        'normal':substate=substates.NORMAL
        'options':substate=substates.OPTIONS
        'pokeselection':substate=substates.POKESELECTION
