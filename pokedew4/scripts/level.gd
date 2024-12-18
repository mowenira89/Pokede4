class_name Level extends Node2D
@onready var tree_layer: TileMapLayer = $TreeLayer
@onready var trees_container: TreesContainer = $Trees
@onready var tree_ref = preload("res://scenes/tree.tscn")
@onready var breakable_rock_ref = preload("res://scenes/breakable_rock.tscn")
@onready var breakable_container: Node2D = $BreakableContainer
@onready var ground_layer: TileMapLayer = $TileMapLayer
@onready var forage_container: Node2D = $ForageContainer
@onready var fieldmon: Node2D = $Fieldmon

const pickup = preload("res://scenes/pickup2.tscn")


var obstructions = {}
var watered_plots = {}

var forage_nodes = {}

var mulch_plots = {}

@export var forest_forage:ForageLootTable
var forest_total=0

func _ready():
    Refs.current_level=self
    Signals.add_obstruction.connect(add_obstruction)
    Signals.remove_obstruction.connect(remove_obstruction)
    Signals.ten_minutes_passed.connect(_on_ten_minutes)
    Signals.one_hour_passed.connect(_on_one_hour)
    set_trees()
    set_forest_forage()

func set_forest_forage():
    var loots = forest_forage.loot_objects
    for x in loots:
         forest_total+=x.rarity
    
    var fn = ground_layer.get_used_cells_by_id(2,Vector2(5,0))
    for x in fn:
        var coord = ground_layer.map_to_local(x)
        forage_nodes[coord]=null
        set_forage(coord,90)


func set_forage(coord:Vector2,forage_chance):
    if randi()%100<forage_chance:
        var i = get_loot()                        
        var p = pickup.instantiate()
        forage_container.add_child(p)
        p.create_pickup(i)
        p.global_position=coord
        forage_nodes[coord]=p
        if randi()%101>forage_chance:
            p.invisible()
        add_obstruction(coord,p)

func get_loot():
    var total
    total=forest_total
    while total>0:
        var t = forest_forage.loot_objects.pick_random()
        total-=t.rarity
        if total<=0:
            var i = Item.new()
            i.data=t
            i.quantity=1
            return i   




func add_watered_plot(v:Vector2i):
    watered_plots[v]=200
        
func _on_ten_minutes():
    for x in watered_plots:
        var amount_to_dry=1
        if x in mulch_plots:
            amount_to_dry-=mulch_plots[x].moisture_retention
        watered_plots[x]-=amount_to_dry
        if watered_plots[x]<=0:
            ground_layer.set_cell(x,2,Vector2(5,2))
            watered_plots.erase(x)
   
func add_obstruction(coord:Vector2,o):
    obstructions[coord]=o
    
func remove_obstruction(coord:Vector2):
    obstructions.erase(coord)

func set_trees():
    var acorns = tree_layer.get_used_cells_by_id(0,Vector2(1,0))
    var oak = load("res://resources/treesources/oak.tres")
    var rocks = tree_layer.get_used_cells_by_id(1,Vector2(0,0))
    var rock = load("res://resources/breakables/rock.tres")
    var woods = tree_layer.get_used_cells_by_id(1, Vector2(3,0))
    var wood = load("res://resources/breakables/wood.tres")
    var fibers = tree_layer.get_used_cells_by_id(1,Vector2(4,0))
    var fiber = load("res://resources/breakables/fiber.tres")
    
    plant_trees(acorns,oak)
    set_rocks(rocks,rock)
    set_rocks(woods,wood)
    set_rocks(fibers,fiber)
    
func set_rocks(coords,data):
    for x in coords:
        var location = tree_layer.map_to_local(x)
        var t = breakable_rock_ref.instantiate()
        breakable_container.add_child(t)
        t.set_breakable(data)
        t.global_position=location
        Signals.add_obstruction.emit(location,t)
        tree_layer.set_cell(x)
    
func plant_trees(acorn_locations,tree):
    for x in acorn_locations:
        var location = tree_layer.map_to_local(x)
        var t = tree_ref.instantiate()
        trees_container.add_child(t)
        t.create_tree(tree,location)
        Signals.add_obstruction.emit(location,t)
        tree_layer.set_cell(x)

func _on_one_hour():
    var forage_spot = forage_nodes.keys().pick_random()
    if forage_nodes[forage_spot]==null:
        set_forage(forage_spot,50)

func add_mulch(tile:Vector2i,mulch:MulchData):
    mulch_plots[tile]=mulch.duplicate()
    tree_layer.set_cell(tile,2,Vector2(0,0))
    
func get_mulch(coord:Vector2i):
    var tile = tree_layer.local_to_map(coord)
    if tile in mulch_plots: return mulch_plots[tile]
    else: return false
