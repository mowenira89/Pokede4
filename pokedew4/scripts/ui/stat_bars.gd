class_name StatBars extends GridContainer

@onready var hp_bar: ProgressBar = $HPBar
@onready var energy_bar: ProgressBar = $EnergyBar

    
func set_bars():
    if Refs.player!=null and Refs.player.data!=null:
        hp_bar.max_value = Refs.player.data.get_stat(Entity.stats.HP)
        hp_bar.value = Refs.player.data.hp
        energy_bar.max_value = Refs.player.data.get_stat(Entity.stats.Energy)
        energy_bar.value = Refs.player.data.energy

func _process(delta: float) -> void:
    set_bars()
