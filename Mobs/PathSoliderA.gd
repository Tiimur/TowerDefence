extends Path2D

var health = 20
var curHealth = health
@onready var healthBar = get_child(0).get_child(0).get_node("ScaleOfHealth")
@export var speed = 350 # скорость моба - солдата

func _ready() -> void:
	healthBar.value = health
	healthBar.max_value = health
	
func _process(delta: float) -> void:
	if healthBar.value <= 0:
		queue_free()
	# устанавливаем значение (set_progress())
	# свойству progress экземпляра PathFollow2D, который получаем через get_parent()
	# результатом суммы текущего значения progress - get_progress()
	# и производения заданной скорости - speed на количество миллисекунд,
	# пройденной с прошлого фрейма (вызова текущего метода _process) - delta
	get_child(0).set_progress(get_child(0).get_progress() + speed * delta)
	healthBar.value = curHealth
	# путь PathFollow2D считается пройденным, когда свойство progress_ratio имеет значение 1,
	# в допустимом диапозоне 0 - 1
	# как только путь был окончен - вызывается безопасный метод удаления узла, который очистит узел
	# в конце текущего фрейма
	# таким образом, как только наш 2D спрайт пройдёт PathFollow до конца - он будет удалён
	if get_child(0).progress_ratio == 1:
		queue_free()
