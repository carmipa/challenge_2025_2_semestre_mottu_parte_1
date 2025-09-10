#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Script: converte-codigo-next-em-txt (versão 7.0 - Estruturado por Pastas)
Descrição:
  Percorre um projeto Next.js/React, concatena todos os arquivos .ts, .tsx
  e arquivos de configuração relevantes em um único arquivo .txt. O conteúdo
  é agrupado por pastas para refletir a estrutura do projeto. O arquivo de
  saída é nomeado 'convert_react_txt.txt'.
"""

import os
import sys
import argparse
from datetime import datetime
from typing import List, Dict
from collections import defaultdict


# ───────────────────────── Funções utilitárias ────────────────────────── #

def gerar_arvore_diretorios(startpath: str) -> str:
    linhas = []
    diretorios_ignorados = {'node_modules', '.next', '.git', 'out'}
    for root, dirs, _ in os.walk(startpath):
        dirs[:] = [d for d in dirs if d not in diretorios_ignorados]
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * level
        linhas.append(f"{indent}{os.path.basename(root)}/")
        dirs.sort()
    return "\n".join(linhas)


# NOVO: Função para obter um tipo descritivo do arquivo
def obter_tipo_arquivo_react(nome_arquivo: str) -> str:
    lname = nome_arquivo.lower()
    if lname.endswith(".tsx"): return "Componente React (.tsx)"
    if lname.endswith(".ts"): return "TypeScript (.ts)"
    if lname == "package.json": return "Definições do Projeto"
    if "next.config." in lname: return "Configuração do Next.js"
    if "tailwind.config." in lname: return "Configuração do TailwindCSS"
    if "tsconfig.json" in lname: return "Configuração do TypeScript"
    return "Arquivo de Código"


# ALTERADO: Função agora busca mais tipos de arquivo na raiz e em 'src'
def listar_arquivos_projeto_react(pasta_projeto: str) -> List[str]:
    arquivos_encontrados = []

    # Lista de arquivos de configuração comuns na raiz
    arquivos_config_raiz = (
        'package.json', 'next.config.mjs', 'next.config.js',
        'tailwind.config.ts', 'tailwind.config.js', 'tsconfig.json',
        'postcss.config.js', 'components.json'
    )

    # Busca arquivos de configuração na raiz
    for nome_arq in arquivos_config_raiz:
        caminho_completo = os.path.join(pasta_projeto, nome_arq)
        if os.path.isfile(caminho_completo):
            arquivos_encontrados.append(caminho_completo)

    # Busca arquivos .ts e .tsx dentro da pasta 'src'
    pasta_src = os.path.join(pasta_projeto, 'src')
    if os.path.isdir(pasta_src):
        exts_codigo = (".ts", ".tsx")
        for root, dirs, files in os.walk(pasta_src):
            if 'node_modules' in dirs: dirs.remove('node_modules')
            for f in files:
                if not f.lower().endswith(".d.ts") and f.lower().endswith(exts_codigo):
                    arquivos_encontrados.append(os.path.join(root, f))

    return sorted(arquivos_encontrados)


# ──────────────────────────── Programa principal ───────────────────────── #

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Concatena arquivos de um projeto Next.js em um .txt, agrupado por pastas."
    )
    parser.add_argument("project_path", nargs="?",
                        help="(Opcional) Caminho da pasta raiz do projeto")
    args = parser.parse_args()

    projeto_path = args.project_path or input(
        "Informe o caminho da pasta do projeto: ").strip()

    if not os.path.isdir(projeto_path):
        print(f"Erro: '{projeto_path}' não é um diretório válido.")
        sys.exit(1)

    nome_projeto = os.path.basename(os.path.normpath(projeto_path))
    # ALTERADO: Nome do arquivo de saída fixo
    arquivo_saida = "convert_react_txt.txt"
    agora = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    arquivos_projeto = listar_arquivos_projeto_react(projeto_path)

    if not arquivos_projeto:
        print("Nenhum arquivo relevante foi encontrado. Nenhum arquivo gerado.")
        sys.exit(0)

    # NOVO: Lógica para agrupar arquivos por pasta
    arquivos_agrupados: Dict[str, List[str]] = defaultdict(list)
    chave_config = "[Arquivos de Configuração]"

    for arq in arquivos_projeto:
        rel_path = os.path.relpath(arq, projeto_path)
        if 'src' in rel_path.split(os.sep):
            # Agrupa pela pasta pai
            grupo = os.path.dirname(rel_path)
            arquivos_agrupados[grupo].append(arq)
        else:
            # Agrupa arquivos da raiz na chave de configuração
            arquivos_agrupados[chave_config].append(arq)

    linha_sep_curta = "//" + "―" * 100 + "\n"
    linha_sep_longa = "/" * 110 + "\n"

    with open(arquivo_saida, "w", encoding="utf-8") as out:
        out.write(f"// Script: converte-codigo-next-em-txt (v7.0)\n")
        out.write(f"// Projeto: {nome_projeto}\n")
        out.write(f"// Data de geração: {agora}\n\n")
        out.write("// Estrutura de diretórios do projeto (simplificada):\n")
        out.write(gerar_arvore_diretorios(projeto_path))
        out.write("\n\n")

        # NOVO: Índice de Pastas e Arquivos
        out.write("// Índice de Pastas e Arquivos:\n")
        chaves_ordenadas = sorted(arquivos_agrupados.keys(), key=lambda x: (x != chave_config, x))
        for grupo in chaves_ordenadas:
            out.write(f"//   PASTA: {grupo}\n")
            for arq in sorted(arquivos_agrupados[grupo]):
                out.write(f"//     - {os.path.basename(arq)}\n")
        out.write("\n")

        # NOVO: Conteúdo agrupado por pastas
        for grupo in chaves_ordenadas:
            out.write(linha_sep_longa)
            out.write(f"// PASTA: {grupo}\n")
            out.write(linha_sep_longa)
            out.write("\n")

            for arq in sorted(arquivos_agrupados[grupo]):
                rel = os.path.relpath(arq, projeto_path)

                try:
                    with open(arq, 'r', encoding="utf-8") as f_in:
                        conteudo = f_in.read()
                except Exception as e:
                    print(f"Aviso: não foi possível ler '{rel}': {e}")
                    continue

                out.write(linha_sep_curta)
                tipo = obter_tipo_arquivo_react(os.path.basename(arq))
                out.write(f"// ARQUIVO: {rel}   |   TIPO: {tipo}\n")
                out.write(linha_sep_curta + "\n")
                out.write(conteudo.rstrip())
                out.write("\n\n\n")

    print(f"Concluído! Arquivo de saída gerado: {arquivo_saida}")


if __name__ == "__main__":
    main()