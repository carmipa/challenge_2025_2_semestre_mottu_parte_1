#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Script: converte-arquivos-csharp-em-txt-unico (versão 1.1.1)
Descrição:
  Percorre recursivamente um projeto C#, concatena todos os .cs
  num único .txt e separa cada arquivo por blocos-comentário contendo
  caminho relativo, namespace e nome do tipo definido (classe, struct, etc.).

Uso:
  python converte_cs_em_txt.py [caminho/do/projeto]
"""

import os
import sys
import argparse
import re
from datetime import datetime
from typing import List, Optional


def gerar_arvore_diretorios(startpath: str) -> str:
    """
    Gera a árvore de diretórios a partir de startpath, incluindo
    pastas e arquivos .cs, de forma hierárquica.
    """
    linhas = []
    # Caminha recursivamente, ordenando diretórios e arquivos para consistência
    for root, dirs, files in os.walk(startpath):
        # Calcula nível de indentação a partir de quantas barras há entre root e startpath
        level = root.replace(startpath, '').count(os.sep)
        indent_dir = ' ' * 4 * level
        nome_dir = os.path.basename(root) or os.path.abspath(root)
        linhas.append(f"{indent_dir}{nome_dir}/")
        dirs.sort()

        # Para cada arquivo dentro dessa pasta, mostra com indentação extra
        for f in sorted(files):
            if f.endswith('.cs'):
                indent_file = ' ' * 4 * (level + 1)
                linhas.append(f"{indent_file}{f}")
    return "\n".join(linhas)


def extrair_namespace(txt: str) -> Optional[str]:
    """
    Extrai o namespace declarado no arquivo C#, se existir.
    """
    m = re.search(r'^\s*namespace\s+([\w\.]+)', txt, re.MULTILINE)
    return m.group(1) if m else None


def extrair_nome_tipo(txt: str) -> Optional[str]:
    """
    Extrai o nome do primeiro tipo definido no arquivo C#
    (class, struct, interface ou record), se existir.
    """
    m = re.search(r'\b(class|struct|interface|record)\s+(\w+)', txt)
    return m.group(2) if m else None


def listar_arquivos_cs(pasta: str) -> List[str]:
    """
    Retorna uma lista de paths de todos os arquivos .cs na pasta
    e subpastas, em ordem alfabética.
    """
    arquivos = []
    for root, _, files in os.walk(pasta):
        for f in files:
            if f.endswith('.cs'):
                arquivos.append(os.path.join(root, f))
    return sorted(arquivos)


def main() -> None:
    parser = argparse.ArgumentParser(
        description='Concatena todos os arquivos .cs em um único .txt com anotações.'
    )
    parser.add_argument(
        'project_path',
        nargs='?',
        help='(Opcional) Caminho absoluto ou relativo da pasta raiz do projeto C#'
    )
    args = parser.parse_args()

    projeto = args.project_path
    if not projeto:
        projeto = input('Informe o caminho da pasta do projeto C#: ').strip()

    if not os.path.isdir(projeto):
        print(f"Erro: '{projeto}' não é um diretório válido.")
        sys.exit(1)

    # Define nome do arquivo de saída (pode ser absoluto ou relativo)
    saida = 'convertidosCsemTxt.txt'
    # Data e hora atuais
    agora = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    # Lista de todos os .cs
    arquivos_cs = listar_arquivos_cs(projeto)

    # Linha de separação entre arquivos (use hífens para compatibilidade)
    linha_sep = '//' + '-' * 100 + '\n'

    try:
        with open(saida, 'w', encoding='utf-8') as out:

            # ========================== Cabeçalho Global ==========================
            out.write('// Script: converte-arquivos-csharp-em-txt-unico (v1.1.1)\n')
            out.write(f'// Data de criação do arquivo de saída: {agora}\n\n')

            # Imprime a árvore de diretórios (com .cs) abaixo do comentário
            out.write('// Estrutura de diretórios do projeto (pastas + arquivos .cs):\n')
            out.write(gerar_arvore_diretorios(projeto) + '\n\n')

            # Lista resumida dos arquivos encontrados (Namespace.Tipo => caminho relativo)
            out.write('// Arquivos encontrados (Namespace.Tipo => caminho relativo):\n')
            for arq in arquivos_cs:
                rel = os.path.relpath(arq, projeto)
                # Tenta ler o arquivo; se der problema de codificação, lê ignorando erros
                try:
                    with open(arq, 'r', encoding='utf-8', errors='ignore') as f:
                        txt = f.read()
                except Exception:
                    txt = ''
                nome_tipo = extrair_nome_tipo(txt) or os.path.splitext(os.path.basename(arq))[0]
                namespace = extrair_namespace(txt)
                fqn = f"{namespace}.{nome_tipo}" if namespace else nome_tipo
                out.write(f'// {fqn} => {rel}\n')
            out.write('\n')

            # ==================== Conteúdo de cada arquivo .cs ====================
            for arq in arquivos_cs:
                rel = os.path.relpath(arq, projeto)
                try:
                    with open(arq, 'r', encoding='utf-8', errors='ignore') as f:
                        conteudo = f.read()
                except Exception:
                    conteudo = ''

                nome_tipo = extrair_nome_tipo(conteudo) or os.path.splitext(os.path.basename(arq))[0]
                namespace = extrair_namespace(conteudo) or '(namespace padrão)'

                # ------------------------------------------------------------
                # 3 linhas em branco antes de cada novo arquivo + bloco de separação
                out.write('\n\n\n')
                out.write(linha_sep)
                out.write(f"// Caminho: {rel}\n")
                out.write(f"// Namespace: {namespace}\n")
                out.write(f"// Tipo: {nome_tipo}\n")
                out.write(linha_sep + '\n')

                # Conteúdo do próprio arquivo (remove espaçamento extra no final)
                out.write(conteudo.rstrip())
                out.write('\n')  # Garante linha em branco no final de cada arquivo
                # ------------------------------------------------------------

        print(f"Concluído! Arquivo de saída gerado: {saida}")

    except IOError as e:
        print(f"Erro ao escrever o arquivo de saída: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
