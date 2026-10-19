extends RefCounted

var direcoes: Array[Vector2i] = [
	Vector2i(-1,0),
	Vector2i(1,0),
	Vector2i(0,-1),
	Vector2i(0,1)
]

var mapa: Array[String] = [
	"###!!#%#",
	"@@#!!#%#",
	"@!!!!#%#",
	"@@!!!!%#",
	"#@%#@###",
	"@@@#$$$$",
	"@@@#$$$$",
	"@@@#$###",
	"@@@#$$$#",
	"$$##$###",
	"$$#%$$%%",
	"$##%#@%%",
	"$$#%!#%%",
	"@@@%!!##",
	"@@#%%%%%",
	"@@#%%%%%",
	"@@#%%%#$",
	"!!!####$",
	"#!!!!!#$",
	"#!!####$",
	"#!%%%%$$",
	"#!%%%###",
	"#!!!$$$$",
    "###!####"
]

var vertices: Dictionary = {}
var grafo: Dictionary = {}

func definir_peso(simbolo: String) -> int:
	match simbolo:
		"!": #grama
			return 1
		"%": #pedra
			return 10
		"@": #areia
			return 4
		"$": #pantano
			return 20
		_:
			push_error("Terreno não definido: " + simbolo)
			return 0 #se chegou aq é pq tá errado

func criar_vertices() -> void:
	for x in range(mapa.size()):
		var linha = mapa[x]
		for y in range(linha.length()):
			var celula = linha[y]
			if celula != "#":
				var nome: String = "V_%d_%d" % [x,y]
				var posicao = Vector2i(x,y)
				vertices[posicao] = Vertice.new(nome, celula)


func criar_arestas() -> void:
	for posicao in vertices:
		var vertice: Vertice = vertices[posicao]
		grafo[vertice] = []
		
		for direcao in direcoes:
			var posicao_vizinha = posicao + direcao
			
			if vertices.has(posicao_vizinha):
				var vizinho: Vertice = vertices[posicao_vizinha]
				var peso = definir_peso(vizinho.terreno)
				
				var aresta: Aresta = Aresta.new(vertice, vizinho, peso)
				
				grafo[vertice].append(aresta)

func calcular_heuristica(x, x_obj, y, y_obj, lista) -> int:
	var custo_min: int = 1
	var distancia: int = abs(x - x_obj) + abs(y - y_obj)
	return distancia * custo_min
