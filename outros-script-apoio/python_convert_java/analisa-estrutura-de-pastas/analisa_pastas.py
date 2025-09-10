#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys

def gerar_estrutura(root_path: str, output_file: str = "estrutura_de_pastas.txt"):
    """
    Percorre recursivamente root_path e escreve em output_file
    todos os diretórios e arquivos encontrados, um por linha,
    com o caminho relativo à raiz.
    """
    if not os.path.isdir(root_path):
        print(f"Erro: '{root_path}' não é um diretório válido.")
        sys.exit(1)

    with open(output_file, "w", encoding="utf-8") as f:
        for dirpath, dirnames, filenames in os.walk(root_path):
            # Caminho relativo da pasta
            rel_dir = os.path.relpath(dirpath, root_path)
            # Se for a própria raiz, use "."
            if rel_dir == ".":
                f.write(f"[DIR] {os.path.basename(root_path)}/\n")
            else:
                f.write(f"[DIR] {rel_dir}/\n")

            # Arquivos dentro dessa pasta
            for filename in filenames:
                rel_file = os.path.join(rel_dir, filename) if rel_dir != "." else filename
                f.write(f"    - {rel_file}\n")

    print(f"Estrutura salva em '{output_file}'.")

def main():
    try:
        root = input("Digite o caminho da pasta a escanear: ").strip()
        gerar_estrutura(root)
    except KeyboardInterrupt:
        print("\nOperação cancelada pelo usuário.")
        sys.exit(0)

if __name__ == "__main__":
    main()
