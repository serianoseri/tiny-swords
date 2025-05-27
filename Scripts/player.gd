extends CharacterBody2D

var input_movement : Vector2 = Vector2.ZERO
enum attack_type{HEAVY, LIGHT}
var animation_skippable : bool = true
var last_direction : Vector2
@onready var animated_sprite = $AnimatedSprite2D
@export var speed:int = 70

func _ready():
	animated_sprite.animation = "idle"
	animated_sprite.play("idle")

func _on_animation_finished():
	animation_skippable = true
	animated_sprite.play("idle")

func _physics_process(delta):
	if animation_skippable:
		move(input_movement)
	#input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	input_movement.x = Input.get_axis("ui_left", "ui_right")
	input_movement.y = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		input_movement.y = 0
	elif Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down"):
		input_movement.x = 0
	else:
		input_movement = Vector2.ZERO
	if animation_skippable:
		if Input.is_action_pressed("heavy_attack"):
			attack(attack_type.HEAVY)
			
		if Input.is_action_pressed("light_attack"):
			attack(attack_type.LIGHT)

func attack(_attack_type):
	animation_skippable = false
	var anim_prefix
	var anim_suffix = "side"
	var anim_name
	var flip_anim = false
	#Attack type choice
	if _attack_type == attack_type.HEAVY:
		anim_prefix = "heavy_attack_"		
	else:
		anim_prefix = "light_attack_"
	#Animation based on the last direction of movement
	if last_direction == Vector2.UP:
		anim_suffix = "up"
	elif last_direction == Vector2.DOWN:
		anim_suffix = "down"
	elif last_direction == Vector2.RIGHT:
		anim_suffix = "side"
	elif last_direction == Vector2.LEFT:
		anim_suffix = "side"
		flip_anim = true
	
	anim_name = str(anim_prefix, anim_suffix)
	animated_sprite.flip_h = flip_anim
	animated_sprite.play(anim_name)

func move(_input_movement):
	if _input_movement == Vector2.LEFT:
		animated_sprite.flip_h = true
	elif _input_movement == Vector2.RIGHT:
		animated_sprite.flip_h = false
	
	if _input_movement != Vector2.ZERO:
		velocity = _input_movement * speed
		last_direction = _input_movement
		animated_sprite.animation = "walk_cycle"
	
	if _input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
		animated_sprite.animation = "idle"
	
	move_and_slide()
