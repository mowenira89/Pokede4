class_name Change_Weather_Ability extends Ability



@export var change_weather_to:Weather.weathers

func on_switch_in():
    match change_weather_to:
        Weather.weathers.RAIN:
            Signals.change_weather.emit('rain')
        Weather.weathers.SUN:
            Signals.change_weather.emit('sun')
