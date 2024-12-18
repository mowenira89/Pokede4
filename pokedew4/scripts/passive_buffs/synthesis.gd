class_name Synthesis extends PassiveBuff

func _ready():
    Signals.ten_minutes_passed.connect(on_ten)
    
    
func on_ten():
    if Refs.weather==Weather.weathers.SUN:
        _owner.change_energy(5)
        _owner.heal(5)
