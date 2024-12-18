class_name BattleStart extends StateBattle
@onready var battle: BattleUI = $"../.."
@onready var player_turn: PlayerTurn = $"../PlayerTurn"

func init():
    pass
    
func enter():
    Signals.switch_state.emit('battle')
    var first_pok 
    if Refs.player.following_mon!=null:
        first_pok=Refs.player.following_mon
    else:
        for x in Refs.pokemon_order:
            if x!=null and x.location==Pokemon.locations.BALL:
                
                first_pok=Refs.captured_pokemon[x]
                Refs.currently_battling=first_pok
                break
    state_machine.switch_in_player_pokemon(first_pok)

func exit():
    pass
    
func process(delta)->StateBattle:
   
        return null
        
func physics(delta)->StateBattle:
    return null

func handle_input(event)->StateBattle:
    return null
