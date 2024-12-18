class_name PokeSlot extends ColorRect
@onready var icon: TextureRect = $MarginContainer/TextureRect
@onready var options: ColorRect = $Options

signal left_clicked

var index:int

func set_slot(i:int):
    index = i
    if index<Refs.pokemon_order.size() and Refs.pokemon_order[i]!=null:
        var p = Refs.captured_pokemon[Refs.pokemon_order[i]]
        icon.texture = p.image
        if p.status==Entity.main_status.FNT:
            modulate="#cc3333"


func _on_gui_input(event: InputEvent) -> void:
    if event.is_action_pressed("click"):
        left_clicked.emit(self)

func be_hovered_over():
    self_modulate="#ff00ff"
    
func select():
    self_modulate="#ffff00"
    
func deselect():
    self_modulate="#ffffff"
    
func show_options():
    options.visible=true
    options.connect_signal()
    
func hide_options():
    options.visible=false
    options.disconnect_signal()
