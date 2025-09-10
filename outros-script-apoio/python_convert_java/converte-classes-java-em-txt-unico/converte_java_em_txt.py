#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Script: converte-projeto-java-em-txt-unico (versão 5.1 - Nome de arquivo fixo)
Descrição:
  Percorre um projeto Java e cria um único arquivo .txt com todo o código
  e arquivos de configuração relevantes. O conteúdo é agrupado por pacotes
  Java para refletir a estrutura lógica do projeto, com cabeçalhos claros
  para cada seção. O arquivo de saída é nomeado 'projeto_java_txt.txt'.

Uso:
  python converte_java_completo.py [caminho/do/projeto]
"""

import os
import sys
import argparse
import re
from collections import defaultdict
from datetime import datetime
from typing import List, Optional, Dict


# ───────────────────────── Funções utilitárias (sem alterações) ────────────────────────── #

def gerar_arvore_diretorios(startpath: str) -> str:
    linhas = []
    diretorios_ignorados = {'target', 'build', '.gradle', '.idea', 'bin'}
    for root, dirs, _ in os.walk(startpath):
        dirs[:] = [d for d in dirs if d not in diretorios_ignorados]
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * level
        linhas.append(f"{indent}{os.path.basename(root)}/")
        dirs.sort()
    return "\n".join(linhas)


def extrair_nome_classe(txt: str) -> Optional[str]:
    m = re.search(r'\b(class|interface|enum)\s+(\w+)', txt)
    return m.group(2) if m else None


def extrair_pacote(txt: str) -> Optional[str]:
    m = re.search(r'^\s*package\s+([\w\.]+)\s*;', txt, re.MULTILINE)
    return m.group(1) if m else None


def obter_tipo_arquivo(nome_arquivo: str) -> str:
    lname = nome_arquivo.lower()
    if lname.endswith(".java"): return "Classe Java"
    if lname == "pom.xml": return "Maven Build File"
    if lname.startswith("build.gradle"): return "Gradle Build File"
    if lname.startswith("application."): return "Configuração Spring"
    return "Arquivo de Projeto"


def listar_arquivos_projeto(pasta: str) -> List[str]:
    arquivos_encontrados = []
    arquivos_config = ('pom.xml', 'build.gradle', 'build.gradle.kts', 'application.properties', 'application.yml',
                       'application.yaml')
    for root, _, files in os.walk(pasta):
        if any(d in root for d in ['/target/', '/build/', '/.gradle/']): continue
        for f in files:
            if f.lower().endswith(".java") or f.lower() in arquivos_config:
                arquivos_encontrados.append(os.path.join(root, f))
    return sorted(arquivos_encontrados)


# ──────────────────────────── Programa principal ───────────────────────── #

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Concatena arquivos de um projeto Java em um único .txt, agrupados por pacote."
    )
    parser.add_argument("project_path", nargs="?",
                        help="(Opcional) Caminho da pasta raiz do projeto Java")
    args = parser.parse_args()

    projeto_path = args.project_path or input(
        "Informe o caminho da pasta do projeto Java: ").strip()

    if not os.path.isdir(projeto_path):
        print(f"Erro: '{projeto_path}' não é um diretório válido.")
        sys.exit(1)

    nome_projeto = os.path.basename(os.path.normpath(projeto_path))

    # ALTERADO: Nome do arquivo de saída agora é fixo.
    arquivo_saida = "projeto_java_txt.txt"

    agora = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    arquivos_projeto = listar_arquivos_projeto(projeto_path)

    if not arquivos_projeto:
        print("Nenhum arquivo relevante foi encontrado. Nenhum arquivo gerado.")
        sys.exit(0)

    # Lógica para agrupar arquivos por pacote...
    arquivos_agrupados: Dict[str, List[str]] = defaultdict(list)
    chave_config = "[Arquivos de Configuração e Build]"

    for arq in arquivos_projeto:
        if arq.lower().endswith(".java"):
            try:
                with open(arq, 'r', encoding='utf-8', errors='ignore') as f:
                    conteudo_temp = f.read()
                pacote = extrair_pacote(conteudo_temp) or "(pacote padrão)"
                arquivos_agrupados[pacote].append(arq)
            except Exception:
                arquivos_agrupados["(erro na leitura)"].append(arq)
        else:
            arquivos_agrupados[chave_config].append(arq)

    linha_sep_curta = "//" + "―" * 100 + "\n"
    linha_sep_longa = "/" * 110 + "\n"

    with open(arquivo_saida, "w", encoding="utf-8") as out:
        out.write(f"// Script: converte-projeto-java-em-txt-unico (v5.1)\n")
        out.write(f"// Projeto: {nome_projeto}\n")
        out.write(f"// Data de geração: {agora}\n\n")
        out.write("// Estrutura de diretórios do projeto (simplificada):\n")
        out.write(gerar_arvore_diretorios(projeto_path))
        out.write("\n\n")

        out.write("// Índice de Pacotes e Arquivos:\n")
        chaves_ordenadas = sorted(arquivos_agrupados.keys(), key=lambda x: (x != chave_config, x))
        for pacote in chaves_ordenadas:
            out.write(f"//   PACOTE: {pacote}\n")
            for arq in sorted(arquivos_agrupados[pacote]):
                out.write(f"//     - {os.path.basename(arq)}\n")
        out.write("\n")

        for pacote in chaves_ordenadas:
            out.write(linha_sep_longa)
            out.write(f"// PACOTE: {pacote}\n")
            out.write(linha_sep_longa)
            out.write("\n")

            for arq in sorted(arquivos_agrupados[pacote]):
                rel = os.path.relpath(arq, projeto_path)
                conteudo = ""

                try:
                    with open(arq, 'r', encoding="utf-8") as f_in:
                        conteudo = f_in.read()
                except UnicodeDecodeError:
                    try:
                        with open(arq, 'r', encoding="latin-1") as f_in:
                            conteudo = f_in.read()
                        print(f"Info: O arquivo '{rel}' foi lido com 'latin-1' (fallback).")
                    except Exception as e:
                        print(f"Aviso: Falha ao ler '{rel}' com UTF-8 e latin-1: {e}")
                        continue
                except Exception as e:
                    print(f"Aviso: Não foi possível ler '{rel}': {e}")
                    continue

                out.write(linha_sep_curta)

                if arq.lower().endswith(".java"):
                    classe = extrair_nome_classe(conteudo) or os.path.splitext(os.path.basename(arq))[0]
                    pkg_extraido = extrair_pacote(conteudo) or "(pacote padrão)"
                    out.write(f"// ARQUIVO: {rel}   |   PACOTE: {pkg_extraido}   |   CLASSE: {classe}\n")
                else:
                    tipo = obter_tipo_arquivo(os.path.basename(arq))
                    out.write(f"// ARQUIVO: {rel}   |   TIPO: {tipo}\n")

                out.write(linha_sep_curta + "\n")
                out.write(conteudo.rstrip())
                out.write("\n\n\n")

    print(f"Concluído! Arquivo de saída gerado: {arquivo_saida}")


if __name__ == "__main__":
    main()