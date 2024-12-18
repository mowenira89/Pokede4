class_name Item extends Resource

@export var data:ItemData
@export var quantity:int

func set_item(d:ItemData,q:int):
    data=d
    quantity=q

func create_item(d:String,q:int):
    data=load("res://resources/items/"+d+".tres")
    quantity=q



func use(user,target):
    var uses = []
    for x in data.use_effect:
        uses.append(x.apply(user, target,null,self))
    if data.consumable:    
        for x in uses:
            if x==true:
                InvManager.remove(self,1)
                return
    if data is PlaceableItemData:
        Signals.attempt_placement.emit(maybe_remove,data)

func maybe_remove(c:bool):
    if c: 
        InvManager.remove(self,1)
    else: pass
