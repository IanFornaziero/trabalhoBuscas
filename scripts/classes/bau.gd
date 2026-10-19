class_name Bau
extends RefCounted

var posicao: Vector2i
var recompensa: int
var considerado: bool = false
var resgatado: bool = false

func _init(pos: Vector2i, rec: int) -> void:
	posicao = pos
	recompensa = rec
