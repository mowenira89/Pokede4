class_name NoticeHolder extends VBoxContainer

const notice = preload("res://scenes/ui/notice.tscn")

func _ready():
    Signals.send_notice.connect(add_notice)

func add_notice(s:String):
    var nn = notice.instantiate()
    add_child(nn)
    nn.set_notice(s)
