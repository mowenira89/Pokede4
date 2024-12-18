extends Node

var battle_ref = preload("res://scenes/ui/battleUI.tscn")

var player:Player
var current_level:Level
#id:entity
var captured_pokemon = {}
var pokemon_order = []

var currently_battling:Entity
var current_opponent:Entity

var money=1000

var weather

var misc_holder:Node2D

var known_crafts:Array[CraftableData]=[]
var known_recipes=[]

func _ready():
    var bulbasaur = load("res://resources/pokedata/bulbasaur.tres").duplicate()
    bulbasaur.create_pokemon(50,Pokemon.locations.BALL)
    var sandshrew = load("res://resources/pokedata/sandshrew.tres").duplicate()
    sandshrew.create_pokemon(100,Pokemon.locations.BALL)
    add_pokemon(bulbasaur)
    add_pokemon(sandshrew)
    var craftable = load("res://resources/recipes/chest.tres")
    known_crafts.append(craftable)
    
func get_pokemon_by_index(i:int):
    if i>=pokemon_order.size():return false
    if pokemon_order[i] in captured_pokemon:
        return captured_pokemon[pokemon_order[i]]
    else:
        return false

func add_pokemon(p:Pokemon):
    var n=1
    var id = p.nickname+str(n)
    while id in captured_pokemon:
        n+=1
        id=p.nickname+str(n)
    captured_pokemon[id]=p
    p.id=id
    pokemon_order.append(id)     
    
    
func switch_pokemon_position(first:int, target:int):
    if first>pokemon_order.size() or target>pokemon_order.size():
        pokemon_order.resize([first,target].max()+1)
    var temp = pokemon_order[target]
    pokemon_order[target]=pokemon_order[first]
    pokemon_order[first]=temp

func check_remaining():
    var remaining=0
    for x in captured_pokemon:
        if captured_pokemon[x].status!=Entity.main_status.FNT: remaining+=1
    return remaining
