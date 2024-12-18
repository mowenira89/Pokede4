class_name Player extends CharacterBody2D
@onready var equipped: Sprite2D = $equipped
@onready var cursor_area: Area2D = $Cursor/Area2D

@export var speed:int = 250
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cursor: Sprite2D = $Cursor
var autoaiming:bool=false
var tilemap:TileMapLayer
var last_direction=Vector2.ZERO
var can_move=true
var data:Entity

var targetted_mon:Fieldmon
var targetted_machine:StaticBody2D
var following_mon:Pokemon=null

func _ready():
    Refs.player=self
    tilemap = get_parent().get_child(0)
    data=load("res://resources/pokedata/human.tres")
    data.hp = data.get_stat(Entity.stats.HP)
    data.energy = data.get_stat(Entity.stats.Energy)
    Signals.set_equipment.connect(set_equipment)
    Signals.new_follower.connect(new_follower)
    
func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    if input_direction != Vector2.ZERO:last_direction=input_direction
    velocity = input_direction * speed

func _physics_process(delta):
    if can_move:
        get_input()
        move_and_slide()
        update_animation()
    
func update_animation():
    if velocity.length()==0:
        sprite.stop()
    var direction = "down"
    if velocity != Vector2.ZERO:
        sprite.play("walk")
        sprite.flip_h = true if velocity.x<0 else false


func _on_area_2d_mouse_entered() -> void:
    autoaiming=true


func _on_area_2d_mouse_exited() -> void:
    autoaiming=false
    
func _process(delta: float) -> void:
    if autoaiming:
        cursor.global_position = tilemap.map_to_local(tilemap.local_to_map(get_global_mouse_position()))
    else:
        var tile = tilemap.local_to_map(global_position)
        if last_direction.x>0:tile.x+=1
        if last_direction.x<0:tile.x-=1
        if last_direction.y<0:tile.y-=1
        if last_direction.y>0:tile.y+=1
        cursor.global_position=tilemap.map_to_local(tile)

func get_tile():
    return tilemap.local_to_map(cursor.global_position)

func get_cursor_position():
    return tilemap.map_to_local(tilemap.local_to_map(cursor.global_position))

func get_player_pos():
    return tilemap.map_to_local(tilemap.local_to_map(global_position))

func get_player_tile():
    return tilemap.local_to_map(global_position)

func set_equipment(i:Item):
    if i==null:
        equipped.texture=null
        return
    i.data.set_sprite(equipped)


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("Fieldmon"):
        targetted_mon=body
    elif body.is_in_group("PokeAssignment"):
        targetted_machine=body

func _on_area_2d_body_exited(body: Node2D) -> void:
    if body == targetted_mon:
        targetted_mon=null
    elif body == targetted_machine:
        targetted_machine=null

func new_follower(follower:Pokemon):
    following_mon=follower
