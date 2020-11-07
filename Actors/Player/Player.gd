extends KinematicBody2D

class_name Player

const ACC = 20
const GRAVITY = 12

var direction = 0

var move_x = 0
var move_y = 0

var is_dead := false

var can_move_left := true
var doble_jump := false

func _physics_process(delta):
	if is_dead: return
	
	move_y = clamp(float(GRAVITY + move_y), -800, 200)
	
	direction = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	if direction == 1:
		move_x = Main.speed
#		$Sprites.play("Run")
	elif direction == -1 and can_move_left:
		move_x = -Main.speed
#		$Sprites.play("Run")
	else:
		move_x = lerp(move_x, 0, 0.03)
		$Sprites.play("Idle")
	
	if move_y < 0:
#		$Sprites.play("Jump")
		pass
	
	if is_on_floor():
		move_y = 0
		
		
		
		if Input.is_action_pressed("ui_accept"):
			move_y = -Main.jump
			doble_jump = true
	
	move_and_slide(Vector2(move_x, move_y), Vector2(0, -1))


func dead():
	is_dead = true

func revive():
	is_dead = false
