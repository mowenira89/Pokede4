extends Node

var inventory:InvResource
var selected_index=0

func _ready():
    inventory = InvResource.new()
    inventory.resize(80)
    var axe = Item.new()
    make_one('old_axe')
    make_one('old_hoe')
    make_one('old_pickaxe')
    make_one('squirt_bottle')
    make_ten('oak_acorn')
    make_one('stockpile')
    make_one('manual_mulch_machine')
    make_one('mining_station')
    

func make_one(s:String):
    var i = Item.new()
    i.create_item(s,1)
    add(i)

func make_ten(s:String):
    var i = Item.new()
    i.create_item(s,10)
    add(i)

func add(i:Item):
    inventory.add(i)
    
func remove(i:Item,amount:int):
    inventory.remove(i,amount)

func switch_items(first_inventory:InvResource, first:int, target_inventory:InvResource, target:int):
    var temp = target_inventory.items[target]
    target_inventory.items[target]=first_inventory.items[first]
    first_inventory.items[first]=temp

func equipped():
    return inventory.items[selected_index]
