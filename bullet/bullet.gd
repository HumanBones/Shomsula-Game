extends Node2D

var direction: Vector2 = Vector2.RIGHT

@export var max_speed:float

var speed:float
var dmg:float
var enemy_type:bool = false

func _ready():
	speed = max_speed
	
func _physics_process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func set_dmg(_dmg:float)->void:
	dmg = _dmg

func set_speed(_speed:float) ->void:
	speed = _speed

func set_direction(_direction:Vector2) ->void:
	direction = _direction

func set_bullet_type(_type:bool) ->void:
	enemy_type = _type

func _on_area_2d_area_entered(area):
	#fix dmging player and enemy, do it with hurtbox and hitbox system, too heavy for a bullet to check for collision!
	if area.get_parent().is_in_group("Enemies") && area.get_parent().has_method("take_dmg") && !enemy_type:
		area.get_parent().take_dmg(dmg,direction)
		queue_free()
