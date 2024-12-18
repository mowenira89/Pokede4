class_name ChestUI extends Control

var chest_inv:InvResource
const slot = preload("res://scenes/ui/inv_slot.tscn")
@onready var player_inv_holder: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/ScrollContainer/PlayerInvHolder
var selected_index:int=0
@onready var chest_inv_holder: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/ScrollContainer2/ChestInvHolder

@onready var selected_grid:GridContainer=player_inv_holder

var selected_for_movement

var reserved_slots={}
@export var inv_size:int=30
func _ready():
    chest_inv=InvResource.new()
    chest_inv.resize(inv_size)
    Signals.update_inventory.connect(set_grid)
    

func open():
    visible=true
    selected_grid = player_inv_holder
    Signals.switch_state.emit("mine")
    set_grid()
    set_cursor(0)
    
func set_grid():
    var chest_children = chest_inv_holder.get_children()
    for x in chest_children:
        x.queue_free()
    for x in player_inv_holder.get_children():
        x.queue_free()
    for x in range(0,InvManager.inventory.items.size()-1):
        var new_slot = slot.instantiate()
        player_inv_holder.add_child(new_slot)
        if InvManager.inventory.items[x]!=null:
            new_slot.set_slot(InvManager.inventory.items,x)
    for x in range(0,chest_inv.items.size()-1):
        var new_slot = slot.instantiate()
        chest_inv_holder.add_child(new_slot)
        if x in reserved_slots:
            new_slot.set_reserved_slot(reserved_slots[x],chest_inv,x)
        if chest_inv.items[x]!=null:
            new_slot.set_slot(chest_inv.items,x)
        new_slot.add_to_reserved_slots.connect(add_to_reserved)
        new_slot.remove_from_reserved_slots.connect(remove_from_reserved)


func add_to_reserved(index:int,data:ItemData):
    if index not in reserved_slots:
        reserved_slots[index]=data    
    
func set_cursor(i:int):
        selected_index=clamp(i,0,79)
        var inv_slots=selected_grid.get_children()
        for x in inv_slots:
                if x.requesting:
                    x.set_requested()
                else:
                    x.unselect()
        selected_grid.get_child(selected_index).be_hovered_over()

func switch_grid(d:int):
    match d:
        0:
            selected_grid=player_inv_holder
            for x in chest_inv_holder.get_children():
                x.unselect()
            set_cursor(0)
            selected_index=0
        1:
            selected_grid=chest_inv_holder
            for x in player_inv_holder.get_children():
                x.unselect()
            set_cursor(0)
            selected_index=0
    selected_for_movement=null

func _unhandled_input(event: InputEvent) -> void:
    if visible:
        if event.is_action_pressed('right'):
            set_cursor(selected_index+1)
        elif event.is_action_pressed('left'):
            set_cursor(selected_index-1)
        elif event.is_action_pressed('down'):
            set_cursor(selected_index+5)
        elif event.is_action_pressed('up'):
            set_cursor(selected_index-5)
        elif event.is_action_pressed('cancel'):
            close_chest()
        elif event.is_action_pressed('c'):
            set_for_movement() 
        elif event.is_action_pressed('accept'):
            move_item(modes.ALL)
        elif event.is_action_pressed('CtrlAccept'):
            move_item(modes.ONE)
        elif event.is_action_pressed("ShiftAccept"):
            move_item(modes.TEN)
        elif event.is_action_pressed('q'):
            switch_grid(0)
        elif event.is_action_pressed('r'):
            switch_grid(1)
        elif event.is_action_pressed('f') and get_parent() is Stockpile and selected_grid==chest_inv_holder:
            set_for_request()
        get_viewport().set_input_as_handled()


func set_for_request():
    if selected_index in reserved_slots:
        reserved_slots.erase(selected_index)
        Signals.update_inventory.emit()
    var selected = selected_grid.get_children()[selected_index]
    
    if selected.item!=null:
        selected.set_reserve_status()
        
        
func set_for_movement():
    if selected_for_movement==null:
        selected_for_movement=selected_index
        selected_grid.get_child(selected_index).select()
    else:
        if selected_grid==player_inv_holder:
            InvManager.switch_items(InvManager.inventory,selected_index,InvManager.inventory,selected_for_movement)
            selected_for_movement=null
            set_grid()
        else:
            InvManager.switch_items(chest_inv,selected_for_movement,chest_inv,selected_index)
            set_grid()


func close_chest():
    visible=false
    Signals.switch_state.emit('normal')





enum modes{ALL,TEN,ONE}
func move_item(mode:modes):
    match selected_grid:
        player_inv_holder:
            var item=InvManager.inventory.items[selected_index]
            var index = InvManager.inventory.find(item)
            if item==null:return
            match mode:
                modes.ALL:
                    add_to_chest(item)
                    InvManager.inventory[index]=null
                modes.TEN:
                    if item.quantity-10<0:return false
                    var new_item = Item.new()
                    new_item.quantity=10
                    new_item.data=item.data
                    InvManager.remove(item,10)
                    add_to_chest(new_item)
                modes.ONE:
                    if item.quantity-1<0:return false
                    var new_item = Item.new()
                    new_item.quantity=1
                    new_item.data=item.data
                    InvManager.remove(item,1)
                    add_to_chest(new_item)
        chest_inv_holder:
            var item=chest_inv.items[selected_index]
            var index = chest_inv.find(item)
            if item==null:return
            match mode:
                modes.ALL:
                    InvManager.add(item)
                    remove_from_chest(item,item.quantity)
                modes.TEN:
                    if item.quantity-10<0:return false
                    var new_item = Item.new()
                    new_item.quantity=10
                    new_item.data=item.data
                    InvManager.add(new_item)
                    remove_from_chest(new_item,10)
                modes.ONE:
                    if item.quantity-1<0:return false
                    var new_item = Item.new()
                    new_item.quantity=1
                    new_item.data=item.data
                    InvManager.add(new_item)
                    remove_from_chest(new_item,1)
    set_grid()
    Signals.update_inventory.emit()              

func add_to_chest(i:Item):
    if chest_inv.add(i):
        set_grid()
        return true
    else: return false
            
func remove_from_chest(i:Item,q:int):
    if chest_inv.remove(i,q):
        set_grid()
        return true
    else:
        return false

func remove_from_reserved(slot:int):
    if slot in reserved_slots:
        reserved_slots.erase(slot)
