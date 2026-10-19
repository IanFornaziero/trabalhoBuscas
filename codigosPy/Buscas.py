from grafo import Grafo
from vertice import Vertice
from aresta import Aresta

def busca_largura(vertice_inicio: Vertice, vertice_objetivo: Vertice):
    fronteira = [vertice_inicio]
    expandidos = []
    pai = {vertice_inicio: None}
    visitados = []

    while fronteira:
        vertice_atual = fronteira.pop(0) #tira o primeiro da lista FIFO
        visitados.append(vertice_atual)

        if vertice_atual == vertice_objetivo:
            caminho = criar_caminho(pai, vertice_inicio, vertice_objetivo)
            return caminho

        expandir_vertice(vertice_atual, expandidos, fronteira) #expande o vértice

        adicionar_lista_pai(pai, vertice_atual)

    return []  # Retorna uma lista vazia se não houver caminho encontrado

def busca_profundidade(vertice_inicio: Vertice, vertice_objetivo: Vertice):
    fronteira = [vertice_inicio]
    expandidos = []
    pai = {vertice_inicio: None}
    visitados = []

    while fronteira:
        vertice_atual = fronteira.pop() #tira o último elemento da lista LIFO
        visitados.append(vertice_atual)

        if vertice_atual == vertice_objetivo:
            caminho = criar_caminho(pai, vertice_inicio, vertice_objetivo)
            return caminho

        expandir_vertice(vertice_atual, expandidos, fronteira)

        adicionar_lista_pai(pai, vertice_atual)

    return [] # retorna vazio caso não encontre um caminho

def busca_gulosa(vertice_inicio: Vertice, vertice_objetivo: Vertice):
    fronteira = [vertice_inicio]
    expandidos = []
    pai = {vertice_inicio: None}
    vertice_atual = vertice_inicio
    temp = None

    while fronteira:

        if vertice_atual == vertice_objetivo:
            caminho = criar_caminho(pai, vertice_inicio, vertice_objetivo)
            return caminho

        expandir_vertice(vertice_atual, expandidos, fronteira)
        fronteira.remove(vertice_atual)

        for v in fronteira:
            if v.distancia_objetivo < vertice_atual.distancia_objetivo: #pega o que tem menor distância até o objetivo
                temp = v

        pai[temp] = vertice_atual
        vertice_atual = temp

    return []

def busca_A_star(vertice_inicio: Vertice, vertice_objetivo: Vertice):
    fronteira = [vertice_inicio]
    expandidos = set()
    pai = {vertice_inicio: None}
    peso_acumulado = {vertice_inicio: 0}

    while fronteira:
        vertice_atual = escolher_vertice(fronteira, peso_acumulado)

        fronteira.remove(vertice_atual)

        if(vertice_atual == vertice_objetivo):
            caminho = criar_caminho(pai, vertice_inicio, vertice_objetivo)
            return caminho

        expandidos.add(vertice_atual)

        for aresta in Grafo[vertice_atual]:
            vizinho = aresta.vertice_destino

            novo_custo = calcular_custo(peso_acumulado, vertice_atual, aresta)

            if vizinho not in peso_acumulado or novo_custo < peso_acumulado[vizinho]:
                peso_acumulado[vizinho] = novo_custo
                pai[vizinho] = vertice_atual

                if vizinho not in fronteira:
                    fronteira.append(vizinho)

                expandidos.discard(vizinho)
    
    return []


def expandir_vertice(vertice: Vertice, lista_expandidos, fronteira): #expande o vértice
    if vertice not in lista_expandidos:
        lista_expandidos.append(vertice)

        for aresta in Grafo[vertice]:
            if aresta.vertice_destino not in fronteira:
                fronteira.append(aresta.vertice_destino)
                

def criar_caminho(pai, inicio: Vertice, objetivo: Vertice): #percorre o dic pai para definir o caminho
    caminho = []
    atual = objetivo
    peso_caminho = 0

    while atual is not None:
        caminho.append(atual)

        if atual == inicio:
            break
        
        peso_caminho = aumentar_peso(peso_caminho, atual, pai)

        atual = pai[atual]

    if caminho[-1] != inicio: #ele não achou um caminho
        return []
    
    caminho.reverse() #inverte a lista para que o caminho seja do inicio ao fim
    return caminho, peso_caminho

def adicionar_lista_pai(pai, atual: Vertice): #adiciona o vértice na lista de v_pais
        for aresta in Grafo[atual]: #passa por todas as arestas do vertice
            vizinho = aresta.vertice_destino #pega um destino da aresta

            if vizinho not in pai: #se o v filho já estiver no dicionário de pais, não adiciona pq ele já foi descoberto por outro
                pai[vizinho] = atual #adiciona assim: Vfilho: Vpai

def aumentar_peso(peso_camino, vertice: Vertice, pai): #aumenta o peso do caminho sendo feito
    v_pai = pai[vertice]
    for aresta in Grafo[v_pai]: #percorre as arestas daquele vértice
        if v_pai is not None:
            if aresta.vertice_destino == vertice: #se o vDestino da aresta for o vertice atual, é o caminho usado, eu vou fazer assim pq os valores para ir e para voltar são diferentes
                peso_camino += aresta.peso #adiciona o peso daquela aresta
                break #pra evitar ele passar por arestas desnecessárias, já para na hr q cair no if
    return peso_camino

def calcular_custo(peso_acumulado, vertice_pai: Vertice, aresta: Aresta): #calcula o custo acumulado do vertice para o A*
    return aresta.peso + peso_acumulado[vertice_pai]

def escolher_vertice(fronteira, peso_acumulado): #escolhe o vértice com menor valor para o A*
    vertice_escolhido = None
    custo_escolhido = 0
    custo_atual = 0
    for vertice in fronteira:
        if vertice_escolhido == None: #se o vertice escolhido por null, ele não tem com o que comparar, então só atribui, se for o único, será ele, amém
            vertice_escolhido = vertice
            custo_escolhido = peso_acumulado[vertice] + vertice.distancia_objetivo #pega o custo para comparar em iterações seguidas
        else:
            custo_atual = peso_acumulado[vertice] + vertice.distancia_objetivo
            if custo_atual < custo_escolhido:
                vertice_escolhido = vertice
                custo_escolhido = custo_atual

    return vertice_escolhido