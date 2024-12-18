class_name TreesContainer extends Node2D

func _ready():
    Signals.plant_tree.connect(plant)
    
func plant(d:Treesource, location:Vector2i):
    if location not in Refs.current_level.obstructions:
        var t = load("res://scenes/tree.tscn").instantiate()
        add_child(t)
        t.set_tree(d,location)
    
