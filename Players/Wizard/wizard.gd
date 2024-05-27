extends CharacterBody2D


var speed = 300.0
var jump_velocity = -400.0
var hp

@export var rate_of_fire :float
@export var bullet_holder: Node2D
@export var max_hp: float
@export var bullet_dmg: float

@onready var bullet_scene = preload("res://bullet/bullet.tscn")
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var marker_2d = $Marker2D

var can_shoot :bool
var bullet_dir :Vector2 = Vector2.RIGHT

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	hp = max_hp
	can_shoot = true
	timer.wait_time = rate_of_fire

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta


	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("fire") && can_shoot:
		fire_bullet()
		can_shoot = false
		timer.start()
	
	var direction = Input.get_axis("left", "right")
	
	flip_sprite(direction)
	
	if direction:
		animation_player.play("walk")
	else :
		animation_player.play("idle")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func flip_sprite(direction:float) ->void:
	if direction > 0 :
		sprite_2d.flip_h = false
		bullet_dir = Vector2.RIGHT
	if direction < 0:
		sprite_2d.flip_h = true
		bullet_dir = Vector2.LEFT

func fire_bullet() ->void:
	var bullet = bullet_scene.instantiate() as Node2D
	bullet.set_direction(bullet_dir)
	bullet.global_position = marker_2d.global_position
	bullet.set_dmg(bullet_dmg)
	bullet_holder.add_child(bullet)

func _on_timer_timeout():
	can_shoot = true

