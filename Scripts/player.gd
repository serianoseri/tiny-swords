extends CharacterBody2D

var input_movement : Vector2 = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D
@export var speed:int = 70

func _ready():
	pass

func _physics_process(delta):
	move()

func move():
	input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if input_movement.x < 0:
		animated_sprite.flip_h = true
	elif input_movement.x > 0:
		animated_sprite.flip_h = false
	
	if input_movement != Vector2.ZERO:
		velocity = input_movement * speed
		animated_sprite.animation = "walk_cycle"
		#print(input_movement)
	
	if input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
		animated_sprite.animation = "idle"
	
	move_and_slide()
