class_name CaughtState extends StateBattle

@onready var naming_window: NamingWindow = $"../../NamingWindow"
@onready var end_battle: EndBattleState = $"../EndBattle"

func enter():
    Signals.pokemon_caught.connect(pokemon_caught)
    
func pokemon_caught():
    Signals.add_message.emit(state_machine.opponent_pokemon.nickname+" was caught!")
    Signals.display_messages.emit()
    await Signals.messages_done
    naming_window.set_mon(state_machine.opponent_pokemon)    
    naming_window.visible=true
    await naming_window.naming_complete
    state_machine.change_state(end_battle)
