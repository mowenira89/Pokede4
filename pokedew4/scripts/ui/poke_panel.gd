class_name PokePanel extends ColorRect
@onready var hp_bar: ProgressBar = $MarginContainer/VBoxContainer/HPBar
@onready var energy_bar: ProgressBar = $MarginContainer/VBoxContainer/EnergyBar
@onready var happiness_bar: ProgressBar = $MarginContainer/VBoxContainer/HappinessBar
@onready var level: Label = $MarginContainer/VBoxContainer/HBoxContainer/Level
@onready var nature: Label = $MarginContainer/VBoxContainer/HBoxContainer/Nature
@onready var _name: Label = $MarginContainer/VBoxContainer/Name
@onready var sprite: Sprite2D = $Sprite2D

var mon:Entity

func make_panel(m:Entity):
    mon=m
    hp_bar.max_value=mon.get_stat(Entity.stats.HP)
    hp_bar.value = mon.hp
    energy_bar.max_value=mon.get_stat(Entity.stats.Energy)
    energy_bar.value=mon.energy
    level.text = "lvl. "+str(mon.get_level())
    if mon is Pokemon:
        happiness_bar.max_value=255
        happiness_bar.value=mon.happiness
        nature.text = Pokemon.nats.keys()[mon.nature]
        _name.text=mon.nickname        
        sprite.texture=mon.image
        
    
func select():
    color=Color("#44bfe4")

func deselect():
    color=Color("#b4c1c2")
