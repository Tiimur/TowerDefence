extends StaticBody2D

var bullet = preload("res://Towers/RedBullet.tscn")
var bulletDamage = 3
var pathName = ""
var targets = []
var currTarget = null

func _process(_delta: float) -> void:
	if is_instance_valid(currTarget):
		self.look_at(currTarget.global_position)
	else:
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()

func _on_tower_body_entered(body: Node2D) -> void:
	if "SoliderA" in body.name:
		var tempArr = []
		# получаем тела, которые находятся в площади Area2d
		# в данном случае, это solider, и сама башня 
		targets = get_node("Tower").get_overlapping_bodies()
		# поскольку в список включена и сама башня - нам нужно её отсечь.
		# проходимся по объектам, входящих в площадь, и добавим только те,
		# которые в свойстве name имеет "Solider"
		for i in targets:
			if ("Solider" in i.name):
				tempArr.append(i)
		
		var curTarg = null		
		
		# проходимся по массиву, в котором только солдаты.
		for i in tempArr:
			# если ещё не был установлен какой-либо солдат, как цель.
			if (curTarg == null):
				curTarg = i.get_node("../")
			else:
				# получаем объект PathFollow2D
				var pathFollowNewSolider = i.get_parent()
				# получаем значение свойства progress (по сути - сколько пути прошёл солдат)
				var progressNewSolider = pathFollowNewSolider.get_progress()
				# условие, если новый вошедший солдат прошёл больше (дальше)
				# ранее установленного как текущая цель солдата, то обновляем текущую цель на нового солдата.
				# так нужно, если ранее уставленный солдат как текущая цель
				# уже вышел за зону досягаемости.
				if (progressNewSolider > curTarg.get_progress()):
					curTarg = i.get_node("../")
		# устанавливаем в глобальную переменную текущую цель
		currTarget = curTarg
		pathName = currTarget.get_parent().name
		
		var tempBullet = bullet.instantiate()
		tempBullet.pathName = pathName
		tempBullet.bulletDamage = bulletDamage
		tempBullet.global_position = $Aim.global_position
		get_node("BulletContainer").call_deferred("add_child", tempBullet)

func _on_tower_body_exited(body: Node2D) -> void:
	targets = get_node("Tower").get_overlapping_bodies()
	for i in get_node("BulletContainer").get_child_count():
		if get_node("BulletContainer").get_child(i).target == body:
			get_node("BulletContainer").get_child(i).queue_free()
