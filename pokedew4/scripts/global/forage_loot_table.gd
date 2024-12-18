class_name ForageLootTable extends Resource

@export var loot_objects:Array[ItemData]

var total:int=0



func _ready():
    for x in loot_objects:
        print(x)
        print('printing from ready')
        total+=x.rarity
    
  
