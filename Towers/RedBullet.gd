extends CharacterBody2D

var target = null
var speed = 500
var pathName = ""
var bulletDamage = 0

func _physics_process(_delta: float) -> void:
	# получаем список путей в спавнере, то есть всех солдатов на карте.
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner")
	for i in pathSpawnerNode.get_child_count():
		# если при итерации название текущего пути совпадает с установленным путём, 
		if (pathSpawnerNode.get_child(i).name == pathName):
			var spawner = pathSpawnerNode
			var path = spawner.get_child(i)
			var road = path.get_child(0)
			var solider = road.get_child(0)
			target = solider
	# получаем вектор, направляющийся к цели с заданной скоростью.
	if target == null:
		return
	velocity = global_position.direction_to(target.global_position) * speed
	
	look_at(target.global_position)
	move_and_slide()
	
# когда пуля коснулась моба
func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Solider" in body.name and target == body:
		body.get_parent().get_parent().curHealth -= bulletDamage
		queue_free()
	else:
		var colShape = get_node("Area2D/CollisionShape2D")
		colShape.set_deferred("disabled", true)
	
func _on_area_2d_body_exited(_body: Node2D) -> void:
	get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
