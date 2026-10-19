extends Control

const TAMANHO_CELULA = 32

func _ready() -> void:
	custom_minimum_size = Vector2(
		48 * TAMANHO_CELULA,
		8 * TAMANHO_CELULA
	)
