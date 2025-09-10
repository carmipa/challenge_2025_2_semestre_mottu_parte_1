#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os

def gerar_estrutura(root_path):
    linhas = []
    for root, dirs, files in os.walk(root_path):
        # calcula nível de profundidade
        nivel = root.replace(root_path, '').count(os.sep)
        indent = ' ' * 4 * nivel
        nome_pasta = os.path.basename(root) or root_path
        linhas.append(f'{indent}{nome_pasta}/')
        for arquivo in files:
            linhas.append(f'{indent}{" " * 4}{arquivo}')
    return linhas

def main():
    caminho = input("Digite o caminho do diretório que deseja explorar: ").strip()
    if not os.path.exists(caminho):
        print(f"Erro: o caminho '{caminho}' não existe.")
        return

    estrutura = gerar_estrutura(caminho)

    # exibe no console
    for linha in estrutura:
        print(linha)

    # salva em arquivo (sobrescreve sempre)
    nome_arquivo = 'estrutura-de-pastas.txt'
    with open(nome_arquivo, 'w', encoding='utf-8') as f:
        f.write('\n'.join(estrutura))

    print(f"\nEstrutura salva em '{nome_arquivo}' (arquivo sobrescrito).")

if __name__ == '__main__':
    main()
