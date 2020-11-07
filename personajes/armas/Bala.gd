extends Node2D

onready var tween = $Tween
onready var area = $Area2D
# Called when the node enters the scene tree for the first time.
func _ready():
	tween.connect("tween_all_completed", self, "finished_tween")
	area.connect("body_entered", self, "on_collision")
	pass # Replace with function body.

func shoot(looking_at):
	var new_pos = Vector2(global_position.x + (300 * looking_at), global_position.y)
	tween.interpolate_property($".", "position",
		position, new_pos , 1.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	print(global_position, new_pos)
	
func finished_tween():
	queue_free()

func on_collision(body):
	if("call_hit" in body):
		body.call_hit
	tween.stop_all()
	queue_free()
