extends RefCounted
const buscaScript = preload("res://scripts/funcoes/buscas.gd")

var busca = buscaScript.new()

func busca_bau(vertice_inicial: Vertice, vertice_final: Vertice, bau: Bau, tipoBusca: String, grafo: Dictionary, lista_vertices: Dictionary, posInic: Vector2i , posDest: Vector2i) -> Dictionary:
	var vertice_bau: Vertice = lista_vertices[bau.posicao]
	var dic: Dictionary = {}
	var dic2: Dictionary = {}
	
	var caminho_ate_bau: Array[Vertice] = []
	var caminho_bau_fim: Array[Vertice] = []
	var caminho_completo: Array[Vertice] = []
	
	var peso_ate_bau: int = 0
	var peso_ate_fim: int = 0
	var peso_completo: int = 0
	
	match tipoBusca:
		"largura":
			dic = busca.busca_largura(vertice_inicial, vertice_bau, grafo, lista_vertices)
			dic2 = busca.busca_largura(vertice_bau, vertice_final, grafo, lista_vertices)
			caminho_ate_bau = dic["caminho"]
			caminho_bau_fim = dic2["caminho"]
			peso_ate_bau = dic["peso"]
			peso_ate_fim = dic2["peso"]
			caminho_completo = concatenar_caminho(caminho_ate_bau, caminho_bau_fim)
			peso_completo = definir_custo(peso_ate_bau, peso_ate_fim, bau.recompensa)
			return {"caminho": caminho_completo , "peso": peso_completo}
		
		"profundidade":
			dic = busca.busca_profundidade(vertice_inicial, vertice_bau, grafo, lista_vertices)
			dic2 = busca.busca_profundidade(vertice_bau, vertice_final, grafo, lista_vertices)
			caminho_ate_bau = dic["caminho"]
			caminho_bau_fim = dic2["caminho"]
			peso_ate_bau = dic["peso"]
			peso_ate_fim = dic2["peso"]
			caminho_completo = concatenar_caminho(caminho_ate_bau, caminho_bau_fim)
			peso_completo = definir_custo(peso_ate_bau, peso_ate_fim, bau.recompensa)
			return {"caminho": caminho_completo, "peso": peso_completo}
			
		"gulosa":
			dic = busca.busca_gulosa(vertice_inicial, vertice_bau, grafo, lista_vertices, posDest, posInic)
			dic2 = busca.busca_gulosa(vertice_bau, vertice_final, grafo, lista_vertices, posDest, posInic)
			caminho_ate_bau = dic["caminho"]
			caminho_bau_fim = dic2["caminho"]
			peso_ate_bau = dic["peso"]
			peso_ate_fim = dic2["peso"]
			caminho_completo = concatenar_caminho(caminho_ate_bau, caminho_bau_fim)
			peso_completo = definir_custo(peso_ate_bau, peso_ate_fim, bau.recompensa)
			return {"caminho": caminho_completo, "peso": peso_completo}
			
		"a*":
			dic = busca.busca_A_star(vertice_inicial, vertice_bau, grafo, lista_vertices, posDest, posInic)
			dic2 = busca.busca_A_star(vertice_bau, vertice_final, grafo, lista_vertices, posDest, posInic)
			caminho_ate_bau = dic["caminho"]
			caminho_bau_fim = dic2["caminho"]
			peso_ate_bau = dic["peso"]
			peso_ate_fim = dic2["peso"]
			caminho_completo = concatenar_caminho(caminho_ate_bau, caminho_bau_fim)
			peso_completo = definir_custo(peso_ate_bau, peso_ate_fim, bau.recompensa)
			return {"caminho": caminho_completo, "peso": peso_completo}
		
		_:
			return {} #se chegou aq ta errado

func concatenar_caminho(caminho1: Array[Vertice], caminho2: Array[Vertice]) -> Array[Vertice]:
	var caminho: Array[Vertice] = caminho1.duplicate()
	
	for i in range(1, caminho2.size()):
		caminho.append(caminho2[i])
	
	return caminho

func definir_custo(peso1: int, peso2: int, recompensa: int) -> int:
	var custo: int = peso1 + peso2 - recompensa
	return custo
