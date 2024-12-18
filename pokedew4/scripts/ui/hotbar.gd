class_name Hotbar extends HBoxContainer

@onready var slot_ref = preload("res://scenes/ui/inv_slot.tscn")
var selected_index:int=0
var previewing:Node2D


func _ready():
    set_hotbar()
    Signals.update_inventory.connect(set_hotbar)
    Signals.change_hotbar.connect(change_hotbar)
    Signals.null_preview.connect(func():previewing=null)
    change_hotbar(0)

func set_hotbar():
    for x in get_children():
        x.queue_free()
    for x in 10:
        var slot = slot_ref.instantiate()
        add_child(slot)
        if x==selected_index:
            slot.select()
        if InvManager.inventory.items[x]!=null:
            slot.set_slot(InvManager.inventory.items, x)
        else:
            slot.set_slot(InvManager.inventory.items,x)
        
func change_hotbar(d:int):
    selected_index+=d
    if selected_index>9:
        selected_index=0
    if selected_index<0:
        selected_index=9
    var selected = get_children()[selected_index]
    for x in get_children():
        x.unselect()
    selected.select() 
    Signals.set_equipment.emit(selected.item)
    InvManager.selected_index=selected_index   
    if previewing!=null:
        previewing.queue_free()
    placeable_check(selected)
    
    
func placeable_check(selected:InvSlot):
    if selected.item!=null:
        if selected.item.data is PlaceableItemData:
            previewing=selected.item.data.path_to_scene.instantiate()
            Refs.misc_holder.add_child(previewing)
