class_name ForagePokeState extends PokeState

@onready var pokemon: Fieldmon = $"."
@onready var work_timer: Timer = $WorkTimer
@onready var work_area: Area2D = $"../../WorkArea"
@onready var collider: CollisionShape2D = $"../../WorkArea/CollisionShape2D"

var nearby_forage = []
