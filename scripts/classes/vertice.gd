class_name Vertice
extends RefCounted

var nome: String
var distancia_objetivo: int = 0
var terreno: String
var sprite: String

func _init(nome_vertice: String , terreno_vertice: String) -> void:
	nome = nome_vertice
	terreno = terreno_vertice

	match terreno:
		"!":
			sprite = "res://assets/Terrenos/Sprite_Grama.png"
		
		"%":
			sprite = "res://assets/Terrenos/Sprite_Rocha.png"
			
		"@":
			sprite = "res://assets/Terrenos/Sprite_Areia.png"
		
		"$":
			sprite = "res://assets/Terrenos/Sprite_Pantano.png"
