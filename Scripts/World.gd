extends Node

@onready var anim = $CanvasLayer/SplashScreen/AnimationPlayer
var splashGone

func _ready():
	anim.connect("animation_finished", deactivateSplash)

func _input(event):
	if !splashGone:
		if event is InputEventKey:
			anim.play("fade")

func deactivateSplash(_anim_name):
	splashGone = true
