extends Panel

@onready var PosX = $MargemControles/VBoxControles/PosX
@onready var PosY = $MargemControles/VBoxControles/PosY

@onready var Algoritmos = $MargemControles/VBoxControles/Algoritmos

@onready var Executar = $MargemControles/VBoxControles/Executar
@onready var Limpar = $MargemControles/VBoxControles/Limpar

@onready var Resultado = $MargemControles/VBoxControles/Resultado
@onready var Peso = $MargemControles/VBoxControles/Peso

@onready var LogExec = $MargemControles/VBoxControles/LogExec

const buscaScript = preload("res://scripts/funcoes/buscas.gd")
const buscaBauScript = preload("res://scripts/funcoes/buscasBau.gd")

var busca = buscaScript.new()
var buscaBau = buscaBauScript.new()

var vertices:Dictionary = {}
var posInicial: Vertice = null
var posInic: Vector2i = Vector2i(0,0)
var lista_baus: Array[Bau] = []
var grafo:Dictionary = {}

func _ready() -> void:
	
	
	Algoritmos.add_item("Busca em largura", 1)
	Algoritmos.add_item("Busca em profundidade", 2)
	Algoritmos.add_item("Busca Gulosa", 3)
	Algoritmos.add_item("Busca A*",4)
	
	Executar.pressed.connect(
		_on_executar_pressed
	)
	
	Limpar.pressed.connect(
		_on_limpar_pressed
	)

func _on_limpar_pressed () -> void:
	Resultado.text = "Escolha um destino"
	Peso.text = "Peso: -"
	LogExec.clear()

func _on_executar_pressed () -> void:
	var destino = Vector2i(
		int(PosX.value),
		int(PosY.value)
	)
	
	if not vertices.has(destino):
		Resultado.text = "Destino é uma parede, insira outro"
		return
		
	var vertice_dest: Vertice = vertices[destino]
		
	Resultado.text = "Executando busca..."
	LogExec.clear()
	
	var nomeAlgor = Algoritmos.get_item_text(
		Algoritmos.selected
	)
	
	var resposta:Dictionary = executar_busca_escolhida(nomeAlgor, vertice_dest, destino)
	
	if resposta.is_empty() or not resposta.has("caminho"):
		Resultado.text = "Erro ao executar a busca"
		Peso.text = "0"
		return

	if resposta["caminho"].is_empty():
		Resultado.text = "Não foi possível achar um caminho"
		Peso.text = "0"
		return
		
	Resultado.text = "Caminho encontrado"
	Peso.text = "Peso total: %s" % resposta["peso"]
	
	LogExec.append_text(
		"Algoritmo: %s\n" % nomeAlgor
	)
	LogExec.append_text("Caminho: ")
	for v in resposta["caminho"]:
		LogExec.append_text(
			v.nome + " -> "
		)
	
	
func executar_busca_escolhida(nome: String , destino:Vertice, posDest:Vector2i) -> Dictionary:
	var dic:Dictionary = {}
	var dic_bau:Dictionary = {}
	var dic_bau_temp:Dictionary = {}
	var dic_real:Dictionary = {}
	
	match nome:
		"Busca em largura":
			dic = busca.busca_largura(posInicial, destino, grafo, vertices)
			
			for bau in lista_baus:
				if dic_bau.is_empty():
					dic_bau = buscaBau.busca_bau(posInicial,destino,bau,"largura",grafo,vertices,posDest,posInic)
				else:
					dic_bau_temp = buscaBau.busca_bau(posInicial,destino,bau,"largura",grafo,vertices,posDest,posInic)
					
				if not dic_bau.is_empty() and not dic_bau_temp.is_empty():
					if dic_bau_temp["peso"] < dic_bau["peso"]:
						dic_bau = dic_bau_temp
			
			dic_real = busca.decidir(dic, dic_bau)
			pass
			
		"Busca em profundidade":
			dic = busca.busca_profundidade(posInicial, destino, grafo, vertices)
			
			for bau in lista_baus:
				if dic_bau.is_empty():
					dic_bau = buscaBau.busca_bau(posInicial,destino,bau,"profundidade",grafo,vertices,posDest,posInic)
				else:
					dic_bau_temp = buscaBau.busca_bau(posInicial,destino,bau,"profundidade",grafo,vertices,posDest,posInic)
					
				if not dic_bau.is_empty() and not dic_bau_temp.is_empty():
					if dic_bau_temp["peso"] < dic_bau["peso"]:
						dic_bau = dic_bau_temp
			
			dic_real = busca.decidir(dic, dic_bau)
			pass
		
		"Busca Gulosa":
			dic = busca.busca_gulosa(posInicial, destino, grafo, vertices,posDest,posInic)
			
			for bau in lista_baus:
				if dic_bau.is_empty():
					dic_bau = buscaBau.busca_bau(posInicial,destino,bau,"gulosa",grafo,vertices,posDest,posInic)
				else:
					dic_bau_temp = buscaBau.busca_bau(posInicial,destino,bau,"gulosa",grafo,vertices,posDest,posInic)
					
				if not dic_bau.is_empty() and not dic_bau_temp.is_empty():
					if dic_bau_temp["peso"] < dic_bau["peso"]:
						dic_bau = dic_bau_temp
			dic_real = busca.decidir(dic, dic_bau)
			pass
			
		"Busca A*":
			dic = busca.busca_A_star(posInicial, destino, grafo, vertices,posDest,posInic)
			
			for bau in lista_baus:
				if dic_bau.is_empty():
					dic_bau = buscaBau.busca_bau(posInicial,destino,bau,"a*",grafo,vertices,posDest,posInic)
				else:
					dic_bau_temp = buscaBau.busca_bau(posInicial,destino,bau,"a*",grafo,vertices,posDest,posInic)
					
				if not dic_bau.is_empty() and not dic_bau_temp.is_empty():
					if dic_bau_temp["peso"] < dic_bau["peso"]:
						dic_bau = dic_bau_temp
			
			dic_real = busca.decidir(dic, dic_bau)
			pass
		
		_:
			Resultado.text = "Erro"
			pass
		
	return dic_real
	
func inicializar(lista_vertices: Dictionary,pos_inic:Vector2i, inicio: Vertice, list_baus: Array[Bau], graf) -> void:
	vertices = lista_vertices
	posInicial = inicio
	lista_baus = list_baus
	grafo = graf
	posInic = pos_inic
	return
	
	
	
	
	
	
	
	
	
