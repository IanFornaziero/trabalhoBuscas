extends Node

func _ready() -> void:
	var mapaGUI = $LayoutPrincipal/AreaMapa/MargemMapa/CanvasMapa/Mapa
	var panelGUI = $LayoutPrincipal/PainelControles
	const mapaScript = preload("res://scripts/mapa.gd")
	var mapa = mapaScript.new()
	var posInicial = Vector2i(0,3)
	mapa.criar_vertices()
	mapa.criar_arestas()
	
	var baus_pos: Array[Bau] = [Bau.new(Vector2i(1,0),5), Bau.new(Vector2i(23,3),10), Bau.new(Vector2i(18,5),12), Bau.new(Vector2i(0,6),5), Bau.new(Vector2i(8,6),8)]
	var v_inicio = mapa.vertices[posInicial]
	
	mapaGUI.carregar_mapa(mapa.vertices, mapa.mapa)
	mapaGUI.carregar_baus(baus_pos)
	mapaGUI.carregar_agente(posInicial)
	mapaGUI.carregar_coordeandas()
	panelGUI.inicializar(mapa.vertices,posInicial, v_inicio,baus_pos,mapa.grafo)
	var arquivo = FileAccess.open("user://caminho.txt", FileAccess.WRITE)
	arquivo.store_line("")
	arquivo.close()