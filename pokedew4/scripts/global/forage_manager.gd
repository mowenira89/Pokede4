class_name ForageManager extends Node

var forage_nodes = {}

@onready var ground: TileMapLayer = $"../TileMapLayer"
@onready var trees: TileMapLayer = $"../TreeLayer"
@onready var tree_layer: TreesContainer = $"../Trees"


@export var forest_table:ForageLootTable
@export var coast_table:ForageLootTable
@export var underwater_table:ForageLootTable



var forest_total=0
var coast_total=0

const pickup: = preload("res://scenes/pickup2.tscn")

var loaded:bool=false

func _ready():
   set_initial_forage()            

func set_initial_forage():
    
    var loots = forest_table.loot_objects
    for x in loots:
         forest_total+=x.rarity
    
    var fn = ground.get_used_cells_by_id(2,Vector2(5,0))
    for x in fn:
        var coord = ground.map_to_local(x)
        forage_nodes[coord]=null
        set_forage(coord)
    
    
        
func set_forage(coord:Vector2):
    if randi()%100>50:
        var i = get_loot()                        
        var p = pickup.instantiate()
        tree_layer.add_child(p)
        p.create_pickup(i)
        p.global_position=coord
        forage_nodes[coord]=p
        Refs.current_level.add_obstruction(coord,p)
        if randi()%101<50:
            p.invisible()
        
func get_loot():
    var total
    total=forest_total
    while total>0:
        var t = forest_table.loot_objects.pick_random()
        total-=t.rarity
        if total<=0:
            var i = Item.new()
            i.data=t
            i.quantity=1
            return i   
