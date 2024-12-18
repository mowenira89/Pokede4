class_name GrassContainer extends Node2D

@export var pokemon:Dictionary
@export var min_level:int
@export var max_level:int

var total=0
var current_total=0

func _ready():
    for x in get_children():
        x.get_wild_pokemon.connect(get_wild_pokemon)
    for x in pokemon:
        total+=x

func get_wild_pokemon():
    current_total=total
    var r = randi_range(1,total)
    for x in pokemon:
        r-=x
        if r<=0:
            var pok = pokemon[x]
            var species = pok.duplicate()
            var level = randi_range(min_level,max_level+1)
            species.create_pokemon(level)
            var battle = Refs.battle_ref.instantiate()
            add_child(battle)                
            Signals.battle_started.emit()
            Signals.switch_in_opponent.emit(species)
            Signals.switch_in_player.emit(Refs.player.data)
            return
