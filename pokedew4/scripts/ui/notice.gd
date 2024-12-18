class_name Notice extends Control

@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Panel/Label

func set_notice(s:String):
    label.text=s
    timer.start(5)

func _on_timer_timeout() -> void:
    anim.play('move')
    

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    queue_free()
