class Vertice:
    def __init__(self, nome, terreno , distancia_objetivo=None):
        self.nome = nome #nome do vértice
        self.distancia_objetivo = distancia_objetivo #distância até o objetivo (usado nos algoritmos de busca informados)
        self.terreno = terreno