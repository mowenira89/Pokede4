class_name RestState extends PokeState

@onready var pokemon: Fieldmon = $"../.."
@onready var timer: Timer = $"../../Timer"
var auto=false

func enter():
    timer.start(15)
    timer.timout.connect(rest_timeout)
    
func rest_timeout():
    var energy = pokemon.mon.get_stat(Entity.stats.Energy)
    pokemon.mon.change_energy(5)
    
    
