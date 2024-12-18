class_name ChangeWeather extends Effect


@export var weather:Weather.weathers

func apply(user,target,move=null,item=null):
    Signals.change_weather.emit(weather)
