class_name Station extends Node2D


var assigned_fieldmon:Array[Fieldmon]=[]
@export var placeable:Placeable
@export var chest:ChestUI
const pickup = preload("res://scenes/pickup.tscn")

func init():
    pass

func assign_pokemon(f:Fieldmon):
    if f not in assigned_fieldmon: assigned_fieldmon.append(f)
    
func remove_pokemon(f:Fieldmon):
    assigned_fieldmon.erase(f)

func interact():
    var item = InvManager.equipped()
    if item!= null and item.data is ToolData:
        placeable.remove()
        return

func add(i:Item):
    if chest.add_to_chest(i): return true
    else: 
        var p = pickup.instantiate()
        Refs.misc_holder.add_child(p)
        p.create_pickup(i)
        p.global_position=global_position+Vector2(40,0)
        
func remove_item(i:Item,q:int):
    if chest.remove_from_chest(i,q):
        return true
    else: return false
