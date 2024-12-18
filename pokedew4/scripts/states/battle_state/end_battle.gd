class_name EndBattleState extends StateBattle
@onready var battle: BattleUI = $"../.."
@onready var message: Message = $"../../Message"

func enter():
    if Refs.check_remaining()>0:
        for x in state_machine.was_in_battle:
            x.get_exp("battle",1)
        state_machine.player_pokemon.get_exp('battle',1)
        Signals.add_message.emit(state_machine.opponent_pokemon.nickname+" fainted!")
        Signals.display_messages.emit()
        state_machine.player_pokemon.switch_out()
        await Signals.messages_done
    else:
        Signals.add_message.emit("You've run out of Pokemon!")
        Signals.display_messages.emit()
        await Signals.messages_done
    Signals.switch_state.emit('normal')
    battle.queue_free()

func handle_input(event):
    if event.is_action_pressed('accept'):
        if message.visible:
            Signals.display_messages.emit()
