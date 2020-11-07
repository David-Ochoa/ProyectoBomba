extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const WALK_SPEED = 125 # pixels/sec
const JUMP_SPEED = 300 # pixels/sec

var linear_vel = Vector2()
onready var sprite = $Sprite
onready var animation_tree = $AnimationTree
onready var playBack = animation_tree.get("parameters/playback");
onready var disparo = $Sprite/Disparo
var balas = preload("res://personajes/armas/Bala.tscn")

func _physics_process(delta):
	var root_scene =  get_tree().current_scene
	var current_state = playBack.get_current_node()
	if current_state != "Morir":
		# Apply gravity
		linear_vel += delta * GRAVITY_VEC
		# Move and slide
		linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
		# Detect if we are on floor - only works if called *after* move_and_slide
		var on_floor = is_on_floor()

		var is_attacking = false
		var is_throwing = false
		# Horizontal movement
		var target_speed = 0
		if !"atacar" in current_state:
			if Input.is_action_pressed("move_left"):
				sprite.scale.x = -1
				target_speed -= 1
			if Input.is_action_pressed("move_right"):
				sprite.scale.x = 1
				target_speed += 1
		if Input.is_action_just_pressed("attack"):
			is_attacking = true
			var bala = balas.instance()
			root_scene.add_child(bala)
			bala.position = disparo.global_position
			bala.shoot(sprite.scale.x)
		if Input.is_action_just_pressed("jump") && on_floor:
			linear_vel.y -=JUMP_SPEED 
			
		animation_tree["parameters/conditions/IsAttacking"] = is_attacking
		animation_tree["parameters/conditions/IsMoving"] = (target_speed != 0)
		animation_tree["parameters/conditions/NotIsMoving"] = (target_speed == 0)
		animation_tree["parameters/conditions/NotIsJumping"] = on_floor
		animation_tree["parameters/conditions/IsJumping"] = !on_floor

		target_speed *= WALK_SPEED
		linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)
