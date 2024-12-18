class_name InvSlot extends ColorRect

var inventory:Array[Item]
var index:int
var item:Item
@onready var border: InvSlot = $"."
@onready var option_holder: VBoxContainer = $ColorRect2/MarginContainer/VBoxContainer

@onready var icon: TextureRect = $ColorRect/Icon
@onready var quantity: Label = $ColorRect/Quantity
@onready var options_panel: ColorRect = $ColorRect2

@onready var use: Label = $ColorRect2/MarginContainer/VBoxContainer/Use
@onready var throw: Label = $ColorRect2/MarginContainer/VBoxContainer/Throw
@onready var give: Label = $ColorRect2/MarginContainer/VBoxContainer/Give
@onready var pointer: Sprite2D = $ColorRect2/pointer

var reserved_item:ItemData=null

var requesting=false

signal add_to_reserved_slots
signal remove_from_reserved_slots

var options={}

enum pokemodes {USE,GIVE}
var poke_panel_mode:pokemodes

signal set_container

func _ready():
    options={
    0:use,
    1:throw,
    2:give}

var cursor_position=0

func set_reserve_status():
    if reserved_item==null and item!=null:
        reserved_item=item.data
        set_requested()        
        add_to_reserved_slots.emit(index,item.data)    
    else:
        reserved_item=null
        if item==null:
            icon.texture=null
        select()
        remove_from_reserved_slots.emit(index)
        Signals.update_inventory.emit()
        
        

func set_reserved_slot(i:ItemData,inv:Array[Item],ind:int):
    inventory = inv
    index = ind
    reserved_item=i
    set_requested()
    set_reserve_image()
    
        
func set_reserve_image():
    if reserved_item!=null and item==null:
        icon.texture=reserved_item.image
        icon.self_modulate="#ffffff50"

func change_cursor_position(d:int):
    cursor_position=cursor_position+d
    if cursor_position<0: cursor_position=options.size()-1
    if cursor_position>options.size()-1:cursor_position=0
    pointer.position.y = 14+(30*cursor_position)
    
func set_slot(inv:Array[Item],index:int):
    inventory = inv
    index = index
    item=inventory[index]
    if item!=null:
        item.data.set_sprite(icon)
        quantity.text = str(item.quantity)
        quantity.visible=true
    
    
func unselect():
    border.color=Color("#9c846c")

func select():
    border.color=Color("#38a300")

func set_requested():
    border.color=Color.DARK_GREEN
    requesting=true

    
func be_hovered_over():
    border.color=Color("#3a2018")

func show_options():
    options_panel.visible=true
    
func hide_options():
    options_panel.visible=false
    Signals.toggle_substate.emit("normal")
    
func select_option():
    var t = options[cursor_position].text.to_lower()
    match t:
        'use':
            Signals.open_poke_panel_in_inv.emit()
            Signals.toggle_substate.emit('pokeselection')
            poke_panel_mode=pokemodes.USE
