class_name BattleUI extends CanvasLayer
@onready var state_machine: BattleStateMachine = $StateMachine

@onready var pkmn_menu: PokemonMenu = $PKMNMenu


@onready var player_sprite: Sprite2D = $TextureRect/PlayerSprite
@onready var enemy_sprite: Sprite2D = $TextureRect/EnemySprite
@onready var hp_bar: ProgressBar = $TextureRect/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar2
@onready var hp_label: Label = $TextureRect/ColorRect/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar2/Label
@onready var energy_bar: ProgressBar = $TextureRect/ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/ProgressBar
@onready var energy_label: Label = $TextureRect/ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/ProgressBar/Label

@onready var enemy_hp_bar: ProgressBar = $TextureRect/ColorRect2/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar2
@onready var enemy_hp_label: Label = $TextureRect/ColorRect2/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar2/Label
@onready var enemy_energy_bar: ProgressBar = $TextureRect/ColorRect2/MarginContainer/HBoxContainer/VBoxContainer2/ProgressBar
@onready var enemy_energy_label: Label = $TextureRect/ColorRect2/MarginContainer/HBoxContainer/VBoxContainer2/ProgressBar/Label

@onready var naming_window: NamingWindow = $NamingWindow


func _process(delta: float) -> void:
    set_bars()

func set_bars():
    if state_machine.player_pokemon!=null:
        var p = state_machine.player_pokemon
        var max_hp = p.get_stat(Entity.stats.HP)
        hp_bar.max_value = max_hp
        hp_bar.value=p.hp
        hp_label.text = str(p.hp)+"/"+str(max_hp)
        var max_energy = p.get_stat(Entity.stats.Energy)
        energy_bar.max_value = max_energy
        energy_bar.value = p.energy
        energy_label.text = str(p.energy)+"/"+str(max_energy)
    if state_machine.opponent_pokemon!=null:
        var p = state_machine.opponent_pokemon
        var max_hp=p.get_stat(Entity.stats.HP)
        var max_energy = p.get_stat(Entity.stats.Energy)
        enemy_hp_bar.max_value=max_hp
        enemy_energy_bar.max_value=max_energy
        enemy_hp_bar.value = p.hp
        enemy_energy_bar.value = p.energy
        enemy_hp_label.text = str(p.hp)+"/"+str(max_hp)
        enemy_energy_label.text = str(p.energy)+"/"+str(max_energy)
