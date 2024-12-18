class_name SidePanelController extends MarginContainer

@onready var container: VBoxContainer = $ScrollContainer/PokePanelHolder

const panel = preload("res://scenes/ui/poke_panel.tscn")

var selected_index=0

func _ready():
    Signals.open_poke_panel_in_inv.connect(set_container)

func set_container():
    for x in container.get_children():
        x.queue_free()
    for x in Refs.pokemon_order:
        if x!=null:
            var pp = panel.instantiate()
            container.add_child(pp)
            pp.make_panel(Refs.captured_pokemon[x]) 
            
func move_selected(d:int):
    var children = container.get_children()
    selected_index+=d
    if selected_index>children.size()-1:
        selected_index=0
    if selected_index<0:
        selected_index=children.size()-1
    for x in children:
        x.deselect()
    children[selected_index].select()
    
func close_panels():
    for x in container.get_children():x.queue_free()
    
func get_mon():
    return container.get_children()[selected_index].mon
