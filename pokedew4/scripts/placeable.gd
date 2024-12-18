class_name Placeable extends Node2D

@export var collision_seeker: Area2D
@export var collider: CollisionShape2D
const pickup = preload("res://scenes/pickup.tscn")

var obstructions = []
var previewing:bool=true

var item_path:ItemData

func _ready():
    collision_seeker.area_entered.connect(area_entered)
    collision_seeker.area_exited.connect(area_exited)
    Signals.attempt_placement.connect(attempt_placement)

func _process(delta: float) -> void:
    if previewing:
        get_parent().global_position=Refs.player.get_cursor_position()


func area_entered(area: Area2D) -> void:
    if area.is_in_group("Obstruction"):
        obstructions.append(area)
        

func area_exited(area: Area2D) -> void:
    if area in obstructions:
        obstructions.erase(area)
        
func attempt_placement(c:Callable,d:ItemData):
    if previewing:
        if obstructions.is_empty():
            previewing=false
            if collider!=null:
                collider.disabled=false
            Refs.current_level.add_obstruction(get_parent().global_position,get_parent())        
            c.call(true)
            item_path = d
            if get_parent() is Station:
                get_parent().init()
            Signals.null_preview.emit()

func remove():
    var i = Item.new()
    i.data=item_path
    i.quantity=1
    var p = pickup.instantiate()
    Refs.misc_holder.add_child(p)
    p.create_pickup(i)
    p.global_position=get_parent().global_position
    Refs.current_level.remove_obstruction(get_parent().global_position)
    get_parent().queue_free()
    


func _on_collision_seeker_body_entered(body: Node2D) -> void:
    if body.is_in_group("Obstruction"):
        obstructions.append(body)

func _on_collision_seeker_body_exited(body: Node2D) -> void:
    if body in obstructions:
        obstructions.erase(body)
