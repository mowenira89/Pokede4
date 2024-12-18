class_name BattleProgressBar extends ProgressBar

func _ready():
    Signals.set_stats.connect(set_bar)
    
func set_bar(p:Pokemon):
    max_value=p.level_to_next['battle']
    value = p.exp['battle']
