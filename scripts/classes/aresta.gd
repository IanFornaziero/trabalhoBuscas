class_name Aresta
extends RefCounted

var origem: Vertice
var destino: Vertice
var peso: int

func _init(v_origem: Vertice, v_destino: Vertice, a_peso: int) -> void:
	origem = v_origem
	destino = v_destino
	peso = a_peso
