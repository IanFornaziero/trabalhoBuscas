extends SceneTree

func _initialize() -> void:
	const mapaScript = preload("res://scripts/mapa.gd")
	const buscasScript = preload("res://scripts/funcoes/buscas.gd")
	const buscaBauScript = preload("res://scripts/funcoes/buscasBau.gd")
	var mapa = mapaScript.new()
	var busca = buscasScript.new()
	var buscaBau = buscaBauScript.new()
	mapa.criar_vertices()
	mapa.criar_arestas()
	var posicao_inicial = Vector2i(0,3)
	var posicao_objetivo = Vector2i(3,5)
	
	print("------TESTE DO GRAFO-------")
	print("Quantidade de vértices: ", mapa.vertices.size())
	print("Quantidade de vértices no grafo: ", mapa.grafo.size())
	
	if mapa.vertices.has(posicao_inicial):
		var vertice: Vertice = mapa.vertices[posicao_inicial]
		
		print("Vértice: ", vertice.nome)
		
		for aresta: Aresta in mapa.grafo[vertice]:
			print(
				vertice.nome,
				" -> ",
				aresta.destino.nome,
				" | Peso: ",
				aresta.peso
			)
			
	print("TESTE DE BUSCAS AGORA")
	var v_inicio:Vertice = mapa.vertices[posicao_inicial]
	var v_objetivo:Vertice = mapa.vertices[posicao_objetivo]
	var bau: Bau = Bau.new(Vector2i(6,4),22)
	for posicao in mapa.vertices:
		var v = mapa.vertices[posicao]
		var peso_heuristica: int = mapa.calcular_heuristica(posicao_inicial.x, posicao_objetivo.x, posicao_inicial.y, posicao_objetivo.y)
		v.distancia_objetivo = peso_heuristica
	var dic: Dictionary = busca.busca_A_star(v_inicio,v_objetivo,mapa.grafo, mapa.vertices)
	var dic_bau: Dictionary = buscaBau.busca_bau(v_inicio,v_objetivo,bau, "a*",mapa.grafo, mapa.vertices)
	var dic_real: Dictionary = busca.decidir(dic, dic_bau)
	var caminho: Array[Vertice] = dic_real["caminho"]
	var peso: int = dic_real["peso"]
	
	print("caminho: ")
	for v in caminho:
		print(v.nome)
	
	print("Peso do caminho: ",peso)
	

	quit()
