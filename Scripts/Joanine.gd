extends Enemy

#Store movement in a variable for knockback
#Move again after stopping (player can't stop movement)
#Smart charge direction
#Enraged state
#Jump when enraged
#Pursue player
#Charge after colliding with player?

var fury_speed = 150
var health = 3
var base_speed = 50

func _ready():
	damage = 20

func _physics_process(_delta):
	motion.x = -base_speed
	motion.y += gravity
	if health < 3:
		get_mad()
	if health <= 0:
		queue_free()
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity

func get_mad():
	base_speed = fury_speed * scale.x
	$AnimatedSprite2D.speed_scale = 3
	$WatchYourStep/CollisionShape2Ds.disabled = true

func _on_WatchYourStep_body_exited(_body):
	scale.x = -scale.x
	base_speed = -base_speed
	print(scale.x)
	print(base_speed)
