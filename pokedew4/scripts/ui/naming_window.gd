class_name NamingWindow extends PanelContainer

var mon:Pokemon
@onready var label: Label = $VBoxContainer/Label
@onready var sprite: Sprite2D = $Sprite2D
@onready var te: TextEdit = $VBoxContainer/TextEdit
signal naming_complete

func set_mon(m:Pokemon):
    mon=m
    label.text="Renaming "+mon.nickname+" to:"
    sprite.texture=mon.image
    
func _input(event: InputEvent) -> void:
    if visible:
        if event.is_action_pressed('return'):
            var line = te.get_line(0)
            if line!="":
                mon.nickname=line
            naming_complete.emit()
            queue_free()    
