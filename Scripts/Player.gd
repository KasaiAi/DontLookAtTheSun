extends Actor

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

var acceleration = 80 #50
var max_speed = 300 #250
var jump_height = -800 #-450

var chillTimer = 24
export (int, 0, 100, 20) var health = 100

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
		$Sprite.play("Run")
		chillTimer = 0
	elif Input.is_action_pressed("move_left"):
		motion.x = max(motion.x-acceleration, -max_speed)
		scale.x = scale.y*-1
#		$Sprite.flip_h = true
		$Sprite.play("Run")
		chillTimer = 0
	else:
		friction = true
		if not $AnimationPlayer.is_playing():
			if chillTimer >= 24:
				$Sprite.play("Relax")
			else:
				$Sprite.play("Idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			chillTimer = 0
			motion.y = jump_height
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if not $AnimationPlayer.is_playing():
			if motion.y < 0:
				$Sprite.play("Jump")
			else:
				$Sprite.play("Fall")
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide_with_snap(motion, get_floor_normal(), Vector2.UP, true)

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
	var knockback = pusher.position.x - pushed.position.x
#	print(knockback)
#	print(pusher)
#	print(pushed)
	
	pushed.motion.y = -250
	pushed.motion.x = -knockback * 10
