extends CharacterBody2D

#hp bar				>DONE!
#player damage		>DONE!
#flipping hitbox	>DONE!
#knockback			
#chill timer		
#combo timer		
#i-frames			
#input as signals	
#pursuit			
#splash screen		
#moving attack		
#don't look at the sun
#enemy behavior		
#player powers		

var snap

var gravity = 30 #15

var motion = Vector2()

var acceleration = 80 #50
var max_speed = 300 #250
var jump_height = -800 #-450

var chillTimer = 24
@export var health: int = 100

signal health_changed

func _physics_process(_delta): 
	motion.y += gravity
	chillTimer += 0.1
	var friction = false
	
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("Attack")
		chillTimer = 0
	if Input.is_action_pressed("move_right"):
		motion.x = min(motion.x+acceleration, max_speed)
		scale.x = scale.y*1
#		$Sprite.flip_h = false
		$Sprite2D.play("Run")
		chillTimer = 0
	elif Input.is_action_pressed("move_left"):
		motion.x = max(motion.x-acceleration, -max_speed)
		scale.x = scale.y*-1
#		$Sprite.flip_h = true
		$Sprite2D.play("Run")
		chillTimer = 0
	else:
		friction = true
		if not $AnimationPlayer.is_playing():
			if chillTimer >= 24:
				$Sprite2D.play("Relax")
			else:
				$Sprite2D.play("Idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			chillTimer = 0
			motion.y = jump_height
		if friction == true:
			motion.x = lerp(motion.x, 0.0, 0.2)
	else:
		if not $AnimationPlayer.is_playing():
			if motion.y < 0:
				$Sprite2D.play("Jump")
			else:
				$Sprite2D.play("Fall")
			if friction == true:
				motion.x = lerp(motion.x, 0.0, 0.05)
	
	set_velocity(motion)
	# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `get_floor_normal()`
	set_up_direction(Vector2.UP)
	set_floor_stop_on_slope_enabled(true)
	move_and_slide()
	motion = velocity

#Attempt to turn the animation into a timer for combos
#func _input(event):
#	if $AnimationPlayer.is_playing():
#		return
#	if event == Input.is_action_just_pressed("attack"):
#		$AnimationPlayer.play("Attack2")

func _on_Attack_body_entered(body):
	if body.is_in_group("enemy"):
		body.health -= 1
		knockback(self, body)

func _on_Hurtbox_body_entered(body):
	if body.is_in_group("enemy"):
		health -= body.damage
		emit_signal("health_changed", health)
#		print ("Smooth criminal")
#		print (health)
		knockback(body, self)
		chillTimer = 0

func knockback(pusher, pushed):
	var knock = pusher.position.x - pushed.position.x
#	print(knock)
#	print(pusher)
#	print(pushed)
	
	pushed.motion.y = -250
	pushed.motion.x = -knock * 10
