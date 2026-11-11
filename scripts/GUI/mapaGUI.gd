extends Node2D

const TAMANHO_CELULA: int = 32
const LINHAS: int = 8
const COLUNAS: int = 24
const VELOCIDADE_MOVIMENTO: float = 0.5
const POS_INICAL_AGENTE: Vector2i = Vector2i(0,3)

@onready var Terrenos = $Terrenos
@onready var Baus = $Baus
@onready var Agente = $Agente
@onready var Coordenadas = $Coordenadas
@onready var canvas = get_parent()

func carregar_mapa(vertices: Dictionary, mapa:Array[String]) -> void:
	for posicao in vertices:
		var vertice: Vertice = vertices[posicao]
		
		var sprite = Sprite2D.new()
		sprite.texture = load(vertice.sprite)
		var largura_mapa = 24 * TAMANHO_CELULA
		var altura_mapa = 8 * TAMANHO_CELULA
		
		var deslocamento = Vector2(
			(canvas.size.x - largura_mapa) / 1.5,
			(canvas.size.y - altura_mapa) + 40
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
					(canvas.size.x - largura_mapa) / 1.5,
					(canvas.size.y - altura_mapa) + 40
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
			(canvas.size.x - largura_mapa) / 1.5,
			(canvas.size.y - altura_mapa) + 40
		)

		sprite.position = Vector2(
			bau.posicao.y * TAMANHO_CELULA + TAMANHO_CELULA / 2,
			bau.posicao.x * TAMANHO_CELULA + TAMANHO_CELULA / 2
		) + deslocamento

		Baus.add_child(sprite)

func carregar_agente(pos: Vector2i) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/Agentes/Sprite_Cavaleiro.png")
	sprite.position = Vector2.ZERO
	Agente.position = converter_posicao(pos)
	Agente.add_child(sprite)
	
func carregar_coordeandas() -> void:
	var largura_mapa = 24 * TAMANHO_CELULA
	var altura_mapa = 8 * TAMANHO_CELULA
	
	var deslocamento_coluna = Vector2(
		(canvas.size.x - largura_mapa) / 1.6,
		(canvas.size.y - altura_mapa) + 30
	)
	
	var deslocamento_linha = Vector2(
		(canvas.size.x - largura_mapa) / 1.5,
		(canvas.size.y - altura_mapa) + 20
	)
	
	for coluna in range(COLUNAS):
		var label = Label.new()
		label.text = str(coluna)
		
		label.position = Vector2(
			-10,
			coluna * TAMANHO_CELULA + 12
		) + deslocamento_coluna
		
		Coordenadas.add_child(label)
		
	for linha in range(LINHAS):
		var label = Label.new()
		label.text = str(linha)
		
		label.position = Vector2(
			linha * TAMANHO_CELULA + 7,
			-10
		) + deslocamento_linha
		
		Coordenadas.add_child(label)

func converter_posicao(posicao: Vector2i) -> Vector2:
	var largura_mapa = 24 * TAMANHO_CELULA
	var altura_mapa = 8 * TAMANHO_CELULA
	
	var deslocamento = Vector2(
		(canvas.size.x - largura_mapa) / 1.5,
		(canvas.size.y - altura_mapa) + 40
		)
		
	return Vector2(
		posicao.y * TAMANHO_CELULA + TAMANHO_CELULA / 2,
		posicao.x * TAMANHO_CELULA + TAMANHO_CELULA / 2
	) + deslocamento

func movimentar_agente(caminho: Array[Vertice], vertices: Dictionary) -> void:
	if caminho.is_empty():
		print("caminho vazio")
		return
	
	for vertice in caminho:
		await mover(vertice, vertices)


func mover(prox_vertice: Vertice , vertices:Dictionary) -> void:
	var posicao = vertices.find_key(prox_vertice)
	var destino = converter_posicao(posicao)
	
	print("Vértice: ", prox_vertice.nome)
	print("Coordenada no dicionário: ", posicao)
	print("Destino na tela: ", destino)
	
	var tween = create_tween()
	tween.tween_property(
		Agente,
		"position",
		destino,
		VELOCIDADE_MOVIMENTO
	)
	
	await tween.finished

func resetar_agente() -> void:
	var tween = create_tween()
	var pos = converter_posicao(POS_INICAL_AGENTE)

	tween.tween_property(
		Agente,
		"position",
		pos,
		1
	)