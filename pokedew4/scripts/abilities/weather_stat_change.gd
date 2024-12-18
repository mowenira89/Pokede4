class_name WeatherStatChange extends Ability

var buff:WeatherStatChangeBuff

func init(o):
    super(o)
    o.add_buff(buff)
