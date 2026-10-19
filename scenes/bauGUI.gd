extends Node2D

@onready var Baus = $Baus
var TAMANHO_CELULA = 24

func carregar_baus(posicoes_baus: Array[Vector2i]) -> void:
	for posicao in posicoes_baus:
		var sprite = Sprite2D.new()
		sprite.texture = load("res://assets/Objetos/Sprite_Bau_Cheio.png")

		sprite.position = Vector2(
			posicao.y * TAMANHO_CELULA + TAMANHO_CELULA / 2,
			posicao.x * TAMANHO_CELULA + TAMANHO_CELULA / 2
		)

		Baus.add_child(sprite)
