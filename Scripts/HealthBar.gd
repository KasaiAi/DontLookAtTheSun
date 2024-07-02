extends Control

func _on_Player_health_changed(value):
	$HealthMeter.value = value
	$HealthMeter/Label.text = str(value)
