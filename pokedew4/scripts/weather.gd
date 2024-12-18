class_name Weather extends Node

enum weathers {NORMAL,SUN,RAIN,HAIL}
var weather:weathers=0
var turns=0


func _ready():
    Signals.one_hour_passed.connect(one_hour)
    Refs.weather=weather
    Signals.change_weather.connect(_change_weather)
    
func one_hour():
    if weather==weathers.NORMAL:
        if randi()%255<30:
            start_rain()
    elif weather==weathers.RAIN:
        turns-=1
        if turns<=0:
            start_rain()
    elif weather==weathers.SUN:
        if randi()%101<30:
            start_normal()
    Refs.weather=weather
    
func start_rain():
    weather=weathers.RAIN
    turns=randi_range(1,25)
    
func start_normal():
    weather=weathers.NORMAL
        
func start_sun():
    weather=weathers.SUN

#used from signal
func _change_weather(w:weathers):
    weather=w
