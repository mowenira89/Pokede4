class_name Clock extends Node

@onready var timer: Timer = $Timer
@onready var _hour: Label = $MarginContainer/HBoxContainer/Hour
@onready var _minute: Label = $MarginContainer/HBoxContainer/Minute


var hour:int = 6
var minute:int = 0
var am = true
var day = 1

func _ready():
    timer.start(10)
    set_clock()

func _on_timer_timeout() -> void:
    minute+=1
    if minute==6:
        minute=0
        hour+=1
        Signals.one_hour_passed.emit()
        if hour==12:
            am = !am
            if am: day+=1
        if hour==13:
            hour=1
    set_clock()
    Signals.ten_minutes_passed.emit()

func set_clock():
    _hour.text=str(hour)
    _minute.text=str(minute)+"0"
