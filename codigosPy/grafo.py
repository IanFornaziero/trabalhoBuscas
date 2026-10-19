from vertice import Vertice
from aresta import Aresta

#LEGENDA:
# # = PAREDE
# ! = GRAMA
# @ = AREIA
# $ = PANTANO
# % = PEDRA

mapa = [
    "###!!#%#",
    "@@#!!#%#",
    "@!!!!#%#",
    "@@!!!!%#",
    "#@%#@###",
    "@@@#@$$$",
    "@@@#@$$$",
    "@@@#$###",
    "@@@#$$$#",
    "$$##$###",
    "$$#%@@%%",
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

direcoes = [
    (-1,0),
    (1,0),
    (0,-1),
    (0,1)
]

vertices = {}

Grafo = {}

def criar_vertices():
    for x, linha in enumerate(mapa):
        for y, celula in enumerate(linha):
            if celula != "#":
                nome = f"V_{x}_{y}"
                vertices[(x,y)] = Vertice(nome, celula)

def criar_arestas():
    for (x,y), vertice in vertices:
        Grafo[vertice] = []

        for dx,dy in direcoes:
            posicao_vizinha = (x + dx, y + dy)

            if posicao_vizinha in vertices:
                peso = definir_peso(vizinho.terreno)
                vizinho = vertices[posicao_vizinha]
                aresta = Aresta(vertice, vizinho, peso)
                Grafo[vertice].append(aresta)

def definir_peso(simbolo):
    match simbolo:
        case "!": #grama
            return 1
        case "%": #pedra
            return 10
        case "@": #areia
            return 4
        case "$": #pantano
            return 20
        case _:
            return 0 #se chegou aq ta errado

def calcular_heuristica(x,y,obj_x,obj_y): #heuristica manhatam, já que ele só pode ir para cima, baixo, esquerda e direita
    custo_min = 1
    distancia = abs(x - obj_x) + abs(y - obj_y)

    return distancia * custo_min #multiplica para não subestimar nem superestimar o custo do caminho