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
	motion = move_and_slide(motion, Vector2.UP)

func get_mad():
	base_speed = fury_speed * scale.x
	$AnimatedSprite.speed_scale = 3
	get_node("WatchYourStep/CollisionShape2D").disabled = true

func _on_WatchYourStep_body_exited(_body):
	scale.x = -scale.x
	base_speed = -base_speed
	print(scale.x)
	print(base_speed)
