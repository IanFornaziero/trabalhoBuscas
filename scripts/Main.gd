extends Node

func _ready() -> void:
	var mapaGUI = $LayoutPrincipal/AreaMapa/MargemMapa/CanvasMapa/Mapa
	var panelGUI = $LayoutPrincipal/PainelControles
	const mapaScript = preload("res://scripts/mapa.gd")
	const buscasScript = preload("res://scripts/funcoes/buscas.gd")
	const buscaBauScript = preload("res://scripts/funcoes/buscasBau.gd")
	var mapa = mapaScript.new()
	var busca = buscasScript.new()
	var buscaBau = buscaBauScript.new()
	var posInicial = Vector2i(0,3)
	mapa.criar_vertices()
	mapa.criar_arestas()
	
	var baus_pos: Array[Bau] = [Bau.new(Vector2i(1,0),5), Bau.new(Vector2i(23,3),10), Bau.new(Vector2i(18,5),12), Bau.new(Vector2i(0,6),5), Bau.new(Vector2i(8,6),8)]
	var v_inicio = mapa.vertices[posInicial]
	
	mapaGUI.carregar_mapa(mapa.vertices, mapa.mapa)
	mapaGUI.carregar_baus(baus_pos)
	mapaGUI.carregar_agente(posInicial)
	panelGUI.inicializar(mapa.vertices,posInicial, v_inicio,baus_pos,mapa.grafo)


func _process(delta: float) -> void:
	pass
