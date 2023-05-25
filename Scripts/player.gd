extends Area2D

signal hit

@export var speed = 400
var screen_size # size of game window
var velocity

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	velocity = Vector2.ZERO
	
	get_input()
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	set_move(delta)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func get_input():
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
func set_move(delta):
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _on_body_entered(body):
	hide()
	hit.emit()
	# disabled collision after hit to ignore more hit call
	# set_deferred tell godot to wait for best time for this action, if we disalbed fast, maybe is cause problem
	$CollisionShape2D.set_deferred("disabled", true)

