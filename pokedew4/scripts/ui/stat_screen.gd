class_name StatScreen extends ColorRect

const move_panel = preload("res://scenes/ui/move_rect.tscn")
enum modes {NORMAL,BATTLE}
@export var mode:modes
const naming_window = preload("res://scenes/ui/naming_window.tscn")
var pokemon:Pokemon
@onready var name_tag: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/BoxContainer/VBoxContainer/NameTag
@onready var species_tag: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/BoxContainer/VBoxContainer/SpeciesTag
@onready var level_tag: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/BoxContainer/VBoxContainer2/LevelTag
@onready var nature_tag: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/BoxContainer/VBoxContainer2/NatureTag
@onready var sprite: Sprite2D = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/TextureRect/Sprite2D
@onready var moves_container: VBoxContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/MarginContainer/ColorRect/MarginContainer/VBoxContainer
@onready var tutor: Button = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBOX/Tutor
@onready var rename: Button = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/VBOX/Rename

func set_mon(p:Pokemon):
    pokemon = p
    name_tag.text = p.nickname
    species_tag.text = p.species
    level_tag.text = str(p.get_level())
    nature_tag.text = p.get_nature_name(p.nature)
    sprite.texture = p.image
    Signals.set_stats.emit(p)
    set_moves_container()
    
func set_moves_container():
    for x in moves_container.get_children():
        x.queue_free()
    for x in pokemon.current_moves:
        var mp = move_panel.instantiate()
        moves_container.add_child(mp)
        mp.set_rect(x)    
        
func focus_buttons():
    tutor.grab_focus()
            
    


func _on_tutor_pressed() -> void:
    print('tutoring')

func _on_rename_pressed() -> void:
    var nw = naming_window.instantiate()
    $".".add_child(nw)
    nw.set_mon(pokemon)
