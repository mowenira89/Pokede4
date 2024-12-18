class_name Breakable extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var hp:int
var data:BreakableData
@onready var pickup = preload("res://scenes/pickup.tscn")

func set_breakable(d:BreakableData):
    data=d
    hp=data.hp
    sprite.texture = data.sprites.pick_random()    


func get_broken(damage:int):
    hp-=damage
    if hp<=0:
        be_broken()
        
func be_broken():
    var amount = randi_range(1,3)
    for x in amount:
        var p = pickup.instantiate()
        var i = Item.new()
        i.data=data.loot
        i.quantity=1
        get_parent().add_child(p)
        p.create_pickup(i)
        p.global_position = global_position
        Signals.remove_obstruction.emit(global_position)
        queue_free()

func interact():
    var item:Item = InvManager.equipped()
    if item!=null and item.data is ToolData:
        if item.data.tool_type in data.tool_type:
            if data.tool_level<=item.data.tool_level:
                get_broken(item.data.damage)
