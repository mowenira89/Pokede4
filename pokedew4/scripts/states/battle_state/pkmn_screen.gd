class_name PkmnScreenBattleState extends StateBattle

@onready var pkmn_menu: PokemonMenu = $"../../PKMNMenu"
@onready var selection_state: SelectionState = $"../SelectionState"



enum substates {NORMAL,STATS,OPTIONS,FORCED} 
var substate:substates=substates.NORMAL

func enter():
    pkmn_menu.visible=true
    Signals.toggle_substate.connect(toggle_substate)

func exit():
    pkmn_menu.visible=false
    Signals.toggle_substate.disconnect(toggle_substate)

func handle_input(event):
    match substate:
        substates.NORMAL:
            if event.is_action_pressed('right'):
                pkmn_menu.set_cursor(pkmn_menu.selected_index+1)
            if event.is_action_pressed('left'):
                pkmn_menu.set_cursor(pkmn_menu.selected_index-1)
            if event.is_action_pressed('down'):
                pkmn_menu.set_cursor(pkmn_menu.selected_index+10)
            if event.is_action_pressed('up'):
                pkmn_menu.set_cursor(pkmn_menu.selected_index-10)
            if event.is_action_pressed('cancel'):
                pkmn_menu.close_menu()
                return selection_state
            if event.is_action_pressed('c'):
                pkmn_menu.set_for_movement()
            if event.is_action_pressed('accept'):
                pkmn_menu.toggle_option_menu()
                        
        substates.OPTIONS:
            if event.is_action_pressed('down'):
                Signals.select_poke_option.emit(1)
            if event.is_action_pressed('up'):
                Signals.select_poke_option.emit(-1)
            if event.is_action_pressed('cancel'):
                Signals.close_poke_options.emit()
                substate=substates.NORMAL
            if event.is_action_pressed('accept'):
                Signals.choose_poke_option.emit()
                
        substates.STATS:
            if event.is_action_pressed('cancel'):
                pkmn_menu.hide_stat_screen()
            if event.is_action_pressed('right'):
                Signals.change_stat_mode.emit("skill")
            if event.is_action_pressed('left'):
                Signals.change_stat_mode.emit('battle')
            if event.is_action_pressed('down'):
                pkmn_menu.move_stat_screen_down()
            if event.is_action_pressed('up'):
                pkmn_menu.move_stat_screen_up()          
            
        substates.FORCED:
            if event.is_action_pressed('right'):
                pkmn_menu.set_cursor(pkmn_menu.selected_index+1)
            if event.is_action_pressed('left'):
                pkmn_menu.set_cursor(pkmn_menu.selected_index-1)
            if event.is_action_pressed('down'):
                pkmn_menu.set_cursor(pkmn_menu.selected_index+10)
            if event.is_action_pressed('up'):
                pkmn_menu.set_cursor(pkmn_menu.selected_index-10)
                return selection_state
            if event.is_action_pressed('c'):
                pkmn_menu.set_for_movement()
            if event.is_action_pressed('accept'):
                pkmn_menu.toggle_option_menu()
    return null
    
func toggle_substate(s:String):
    match s:
        "normal":
            substate=substates.NORMAL
        'stats':
            substate=substates.STATS
        'options':
            substate=substates.OPTIONS
        'forced_select':
            substate=substates.FORCED
