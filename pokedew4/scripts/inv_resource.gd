class_name InvResource extends Resource

@export var inv_size:int
var items:Array[Item]=[]

func add(i:Item):
    for x in items:
        if x!=null and !i.data.unstackable:
            if x.data.item_name==i.data.item_name:
                x.quantity+=i.quantity
                Signals.update_inventory.emit()
                return true
    for x in inv_size:
        if items[x]==null:
            items[x]=i
            Signals.update_inventory.emit()
            return true
    return false
    
func remove(i:Item,quantity):
    if i.quantity-quantity<0:
        return false
    i.quantity-=quantity
    if i.quantity==0:
        var index = items.find(i)
        items[index]=null
    Signals.update_inventory.emit()
    return true

func resize(i:int):
    inv_size=i
    items.resize(i)
    
func is_full():
    for x in items:
        if x==null: return false
    return true
