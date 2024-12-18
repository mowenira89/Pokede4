class_name LootLabel extends Label

@onready var anim: AnimationPlayer = $AnimationPlayer

func set_label(s:String,c:Color):
    text=s
    anim.play("move")
    var x = randi()%500
    var y = randi()%200
    position=Vector2(x,y)
    set("theme_overrides/colors/font_color",c)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    queue_free()
