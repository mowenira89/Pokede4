class_name Message extends NinePatchRect
@onready var label: RichTextLabel = $MarginContainer/RichTextLabel

var active:bool = true
var messages = []

func _ready():
    activate()

func add_message(s:String):
    messages.append(s)

func next_message():
    if !messages.is_empty():
        visible=true
        label.text=messages.pop_at(0)
    else:
        visible=false
        Signals.messages_done.emit()

func deactivate():
    Signals.add_message.disconnect(add_message)
    Signals.display_messages.disconnect(next_message)

func activate():
    Signals.add_message.connect(add_message)
    Signals.display_messages.connect(next_message)


func _on_gui_input(event: InputEvent) -> void:
    if event.is_action_pressed("click"):
        next_message()
