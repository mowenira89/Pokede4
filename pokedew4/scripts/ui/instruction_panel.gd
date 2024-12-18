class_name InstructionPanel extends Panel

@onready var label: Label = $Label


func _ready():
    Signals.set_instruction.connect(show_instruction)
    Signals.close_instruction.connect(hide_instruction)
    
func show_instruction(s:String):
    label.text=s
    visible=true
    
func hide_instruction():
    visible=false    
