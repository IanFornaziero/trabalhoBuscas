extends Node2D

const TAMANHO_CELULA: int = 32

@onready var Terrenos = $Terrenos
@onready var Baus = $Baus
@onready var Agente = $Agente
@onready var canvas = get_parent()

func carregar_mapa(vertices: Dictionary, mapa:Array[String]) -> void:
	for posicao in vertices:
		var vertice: Vertice = vertices[posicao]
		
		var sprite = Sprite2D.new()
		sprite.texture = load(vertice.sprite)
		var largura_mapa = 24 * TAMANHO_CELULA
		var altura_mapa = 8 * TAMANHO_CELULA
		
		var deslocamento = Vector2(
			(canvas.size.x - largura_mapa) / 2,
			(canvas.size.y - altura_mapa) / 2
		)
		
		sprite.position = Vector2(
			posicao.y * TAMANHO_CELULA + TAMANHO_CELULA / 2,
			posicao.x * TAMANHO_CELULA + TAMANHO_CELULA / 2
		)+ deslocamento
		
		Terrenos.add_child(sprite)
		
	for x in range(mapa.size()):
		var linha = mapa[x]
		for y in range(linha.length()):
			var celula = linha[y]
			if celula == "#":
				var posicao: Vector2i = Vector2i(x,y)
				var sprite = Sprite2D.new()
				sprite.texture = load("res://assets/Terrenos/Sprite_Parede.png")
				var largura_mapa = 24 * TAMANHO_CELULA
				var altura_mapa = 8 * TAMANHO_CELULA
				
				var deslocamento = Vector2(
					(canvas.size.x - largura_mapa) / 2,
					(canvas.size.y - altura_mapa) / 2
				)
				
				sprite.position = Vector2(
					posicao.y * TAMANHO_CELULA + TAMANHO_CELULA / 2,
					posicao.x * TAMANHO_CELULA + TAMANHO_CELULA / 2
				) + deslocamento
				Terrenos.add_child(sprite)

func carregar_baus(posicoes_baus: Array[Bau]) -> void:
	for bau in posicoes_baus:
		var sprite = Sprite2D.new()
		sprite.texture = load("res://assets/Objetos/Sprite_Bau_Cheio.png")

		var largura_mapa = 24 * TAMANHO_CELULA
		var altura_mapa = 8 * TAMANHO_CELULA
		
		var deslocamento = Vector2(
			(canvas.size.x - largura_mapa) / 2,
			(canvas.size.y - altura_mapa) / 2
		)

		sprite.position = Vector2(
			bau.posicao.y * TAMANHO_CELULA + TAMANHO_CELULA / 2,
			bau.posicao.x * TAMANHO_CELULA + TAMANHO_CELULA / 2
		) + deslocamento

		Baus.add_child(sprite)

func carregar_agente(pos: Vector2i) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/Agentes/Sprite_Cavaleiro.png")
	
	var largura_mapa = 24 * TAMANHO_CELULA
	var altura_mapa = 8 * TAMANHO_CELULA
		
	var deslocamento = Vector2(
		(canvas.size.x - largura_mapa) / 2,
		(canvas.size.y - altura_mapa) / 2
	)

	sprite.position = Vector2(
		pos.y * TAMANHO_CELULA + TAMANHO_CELULA / 2,
		pos.x * TAMANHO_CELULA + TAMANHO_CELULA / 2
	) + deslocamento
	
	Agente.add_child(sprite)
