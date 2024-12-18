class_name WeatherStatChangeBuff extends Buff

@export var weather:Weather.weathers
@export var stat:Entity.stats

func affect_stat(_stat:int):
    if stat==_stat:
        return _stat*2
    else: return _stat
    
