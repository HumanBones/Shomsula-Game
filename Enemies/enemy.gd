extends CharacterBody2D


var hp :float
var dmg : float
var target: Node2D
var look_dir: Vector2
var speed: float

@export var max_hp :float
@export var push_force: float
@export var max_speed:float
@export var max_bullet_dmg:float
@export var fire_rate:float
@export var bullet_holder:Node2D
@export var shoot_time_range: Vector2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_alive: bool
var bullet_dmg: bool
var can_take_dmg : bool =  true
var is_moving: bool = false
var can_shoot:bool
var knockback: bool = false
var knockback_dir: Vector2 

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var shoot_timer = $ShootTimer
@onready var bullet_sceen = preload("res://bullet/bullet.tscn")
@onready var marker_2d = $Marker2D

func _ready():
	hp = max_hp
	bullet_dmg = max_bullet_dmg
	speed = max_speed
	shoot_timer.wait_time = random_shoot_time(shoot_time_range.x,shoot_time_range.y)
	is_alive = true
	
	target = get_tree().get_nodes_in_group("Players")[0]

func _physics_process(delta):
	
	if !is_moving:
		animation_player.play("idle")
	
	if can_shoot:
		shoot()
		can_shoot = false
		shoot_timer.wait_time = random_shoot_time(shoot_time_range.x,shoot_time_range.y)
	
	if target != null:
		look_dir = (target.position - self.position).normalized()
		look_at_target(look_dir)
	
	
	if hp <=0:
		is_alive = false
		dead()
	
	velocity.x = look_dir.x * speed
	
	if knockback:
		velocity.x = knockback_dir.x * push_force
		knockback = false
	
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func take_dmg(dmg:float,dir:Vector2) ->void:
	if dmg > 0 && can_take_dmg:
		hp -= dmg
		knockback = true
		knockback_dir = dir
		print("Dmg taken: ", dmg)
		print("Hp left: ", hp)
	#singla dmg taken
	#update UI

func dead() -> void:
	queue_free()

func look_at_target(dir:Vector2) ->void:
	if dir.x <= 0 :
		sprite_2d.flip_h = true
	elif dir.x > 0:
		sprite_2d.flip_h = false


func shoot() ->void:
	var bullet_instance = bullet_sceen.instantiate() as Node2D
	bullet_instance.global_position = marker_2d.global_position
	bullet_instance.set_direction(look_dir)
	bullet_instance.set_dmg(bullet_dmg)
	bullet_instance.set_bullet_type(true)
	get_parent().add_child(bullet_instance)
	
	
func _on_shoot_timer_timeout():
	can_shoot = true

func random_shoot_time(_min:float,_max:float)->float:
	randomize()
	return randf_range(_min, _max)
