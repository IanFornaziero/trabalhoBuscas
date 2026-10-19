from vertice import Vertice

class Aresta:
    def __init__(self, origem: Vertice, destino: Vertice, peso:None):
        self.vertice_origem = origem #vértice de origem da aresta
        self.vertice_destino = destino #vértice de destino da aresta
        self.peso = peso #peso da aresta