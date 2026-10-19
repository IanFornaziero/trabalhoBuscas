const mapaScript = preload("res://scripts/mapa.gd")
var mapaaa = mapaScript.new()	


func decidir(dic: Dictionary, dic2: Dictionary) -> Dictionary:
	if dic["peso"] > dic2["peso"]:
		return dic2
	else:
		return dic

func busca_largura(vertice_inicio: Vertice, vertice_objetivo: Vertice, grafo: Dictionary, lista_vertices: Dictionary) -> Dictionary:
	var fronteira: Array[Vertice] = [vertice_inicio]
	var expandidos: Array[Vertice] = []
	var pai: Dictionary = {vertice_inicio: null}
	var visitados: Array[Vertice] = []

	while fronteira:
		var vertice_atual:Vertice = fronteira.pop_front() #tira o primeiro da lista FIFO
		visitados.append(vertice_atual)

		if vertice_atual == vertice_objetivo:
			var caminho: Dictionary = criar_caminho(pai, vertice_inicio, vertice_objetivo, grafo)
			return caminho

		expandir_vertice(vertice_atual, expandidos, fronteira, grafo) #expande o vértice

		adicionar_lista_pai(pai, vertice_atual, grafo)

	return {}  # Retorna uma lista vazia se não houver caminho encontrado

func busca_profundidade(vertice_inicio: Vertice, vertice_objetivo: Vertice, grafo:Dictionary, lista_vertices: Dictionary) -> Dictionary:
	var fronteira:Array[Vertice] = [vertice_inicio]
	var expandidos:Array[Vertice] = []
	var pai:Dictionary = {vertice_inicio: null}
	var visitados:Array[Vertice] = []

	while fronteira:
		var vertice_atual:Vertice = fronteira.pop_back() #tira o último elemento da lista LIFO
		visitados.append(vertice_atual)

		if vertice_atual == vertice_objetivo:
			var caminho:Dictionary = criar_caminho(pai, vertice_inicio, vertice_objetivo, grafo)
			return caminho

		expandir_vertice(vertice_atual, expandidos, fronteira, grafo)

		adicionar_lista_pai(pai, vertice_atual, grafo)

	return {} # retorna vazio caso não encontre um caminho

func busca_gulosa(vertice_inicio: Vertice, vertice_objetivo: Vertice, grafo: Dictionary, lista_vertices: Dictionary, posDest: Vector2i, posInic: Vector2i) -> Dictionary:
	var fronteira:Array[Vertice] = [vertice_inicio]
	var expandidos:Array[Vertice] = []
	var pai:Dictionary = {vertice_inicio: null}
	var vertice_atual:Vertice = vertice_inicio
	var temp:Vertice = null
	
	for posicao in lista_vertices:
		var v = lista_vertices[posicao]
		var peso_heuristica: int = mapaaa.calcular_heuristica(posInic.x, posDest.x, posInic.y, posDest.y,lista_vertices)
		v.distancia_objetivo = peso_heuristica

	while fronteira:
		if vertice_atual == vertice_objetivo:
			var caminho:Dictionary = criar_caminho(pai, vertice_inicio, vertice_objetivo, grafo)
			return caminho

		expandir_vertice(vertice_atual, expandidos, fronteira, grafo)
		adicionar_lista_pai(pai, vertice_atual, grafo)
		fronteira.erase(vertice_atual)
		
		temp = null

		for v in fronteira:
			if temp == null or v.distancia_objetivo < temp.distancia_objetivo: #pega o que tem menor distância até o objetivo
				temp = v
		
		if temp == null:
			break

		vertice_atual = temp

	return {}

func busca_A_star(vertice_inicio: Vertice, vertice_objetivo: Vertice, grafo: Dictionary, lista_vertices: Dictionary, posDest: Vector2i, posInic: Vector2i) -> Dictionary:
	var fronteira:Array[Vertice] = [vertice_inicio]
	var expandidos:Array[Vertice] = []
	var pai:Dictionary = {vertice_inicio: null}
	var peso_acumulado:Dictionary = {vertice_inicio: 0}
	
	for posicao in lista_vertices:
		var v = lista_vertices[posicao]
		var peso_heuristica: int = mapaaa.calcular_heuristica(posInic.x, posDest.x, posInic.y, posDest.y,lista_vertices)
		v.distancia_objetivo = peso_heuristica

	while fronteira:
		var vertice_atual:Vertice = escolher_vertice(fronteira, peso_acumulado)

		fronteira.erase(vertice_atual)

		if(vertice_atual == vertice_objetivo):
			var caminho:Dictionary = criar_caminho(pai, vertice_inicio, vertice_objetivo, grafo)
			return caminho

		expandidos.append(vertice_atual)

		for aresta in grafo[vertice_atual]:
			var vizinho:Vertice = aresta.destino

			var novo_custo:int = calcular_custo(peso_acumulado, vertice_atual, aresta)

			if vizinho not in peso_acumulado or novo_custo < peso_acumulado[vizinho]:
				peso_acumulado[vizinho] = novo_custo
				pai[vizinho] = vertice_atual

				if vizinho not in fronteira:
					fronteira.append(vizinho)

				expandidos.erase(vizinho)
	
	return {}


func expandir_vertice(vertice: Vertice, lista_expandidos: Array, fronteira: Array, grafo:Dictionary) -> void: #expande o vértice
	if vertice not in lista_expandidos:
		lista_expandidos.append(vertice)

		for aresta in grafo[vertice]:
			if aresta.destino not in fronteira and aresta.destino not in lista_expandidos:
				fronteira.append(aresta.destino)

func criar_caminho(pai: Dictionary, inicio: Vertice, objetivo: Vertice, grafo:Dictionary) -> Dictionary: #percorre o dic pai para definir o caminho
	var caminho:Array[Vertice] = []
	var atual:Vertice = objetivo
	var peso_caminho:int = 0

	while atual != null:
		caminho.append(atual)

		if atual == inicio:
			break
			
		if not pai.has(atual):
			return {}

		peso_caminho = aumentar_peso(peso_caminho, atual, pai, grafo)

		atual = pai[atual]

	if caminho[-1] != inicio: #ele não achou um caminho
		return {}
	
	caminho.reverse() #inverte a lista para que o caminho seja do inicio ao fim
	return {"caminho": caminho , "peso": peso_caminho}

func adicionar_lista_pai(pai, atual: Vertice, grafo:Dictionary) -> void: #adiciona o vértice na lista de v_pais
	for aresta in grafo[atual]: #passa por todas as arestas do vertice
		var vizinho:Vertice = aresta.destino #pega um destino da aresta

		if vizinho not in pai: #se o v filho já estiver no dicionário de pais, não adiciona pq ele já foi descoberto por outro
			pai[vizinho] = atual #adiciona assim: Vfilho: Vpai

func aumentar_peso(peso_caminho, vertice: Vertice, pai, grafo:Dictionary) -> int: #aumenta o peso do caminho sendo feito
	var v_pai:Vertice = pai[vertice]
	
	if v_pai == null:
		return peso_caminho

	for aresta in grafo[v_pai]: #percorre as arestas daquele vértice
		if aresta.destino == vertice: #se o vDestino da aresta for o vertice atual, é o caminho usado, eu vou fazer assim pq os valores para ir e para voltar são diferentes
			peso_caminho += aresta.peso #adiciona o peso daquela aresta
			break #pra evitar ele passar por arestas desnecessárias, já para na hr q cair no if
	return peso_caminho

func calcular_custo(peso_acumulado, vertice_pai: Vertice, aresta: Aresta): #calcula o custo acumulado do vertice para o A*
	return aresta.peso + peso_acumulado[vertice_pai]

func escolher_vertice(fronteira, peso_acumulado) -> Vertice: #escolhe o vértice com menor valor para o A*
	var vertice_escolhido:Vertice = null
	var custo_escolhido:int = 0
	var custo_atual:int = 0
	
	for vertice in fronteira:
		if vertice_escolhido == null: #se o vertice escolhido por null, ele não tem com o que comparar, então só atribui, se for o único, será ele, amém
			vertice_escolhido = vertice
			custo_escolhido = peso_acumulado[vertice] + vertice.distancia_objetivo #pega o custo para comparar em iterações seguidas
		else:
			custo_atual = peso_acumulado[vertice] + vertice.distancia_objetivo
			
			if custo_atual < custo_escolhido:
				vertice_escolhido = vertice
				custo_escolhido = custo_atual

	return vertice_escolhido
