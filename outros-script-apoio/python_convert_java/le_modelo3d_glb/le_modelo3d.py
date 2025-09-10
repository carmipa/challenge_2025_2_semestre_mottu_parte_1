import os
from tkinter import Tk, filedialog, TclError
from pygltflib import GLTF2
from datetime import datetime

def escolher_arquivo():
    try:
        root = Tk()
        root.withdraw()
        return filedialog.askopenfilename(title="Selecione um arquivo .glb", filetypes=[("GLB files", "*.glb")])
    except TclError as e:
        print(f"[ERRO] Janela gráfica falhou: {e}")
        return None

def gerar_estrutura_diretorios(raiz):
    saida = ["\n📁 Estrutura de Diretórios:\n"]
    for dirpath, _, filenames in os.walk(raiz):
        nivel = dirpath.replace(raiz, '').count(os.sep)
        indent = '│   ' * nivel
        pasta = os.path.basename(dirpath)
        saida.append(f"{indent}├── {pasta}/")
        sub_indent = '│   ' * (nivel + 1)
        for f in filenames:
            saida.append(f"{sub_indent}└── {f}")
    return "\n".join(saida)

def detalhar_glb(glb: GLTF2):
    saida = []

    if glb.nodes:
        saida.append(f"\n🧱 NÓS ({len(glb.nodes)}):")
        for i, node in enumerate(glb.nodes):
            nome = node.name or f"Nó {i}"
            filhos = node.children or []
            saida.append(f"  ▸ {nome} (index {i}) → Filhos: {filhos}")

    if glb.meshes:
        saida.append(f"\n🎛️ MALHAS ({len(glb.meshes)}):")
        for i, mesh in enumerate(glb.meshes):
            saida.append(f"  ▸ Malha {i}: {mesh.name or '[sem nome]'}")
            for j, prim in enumerate(mesh.primitives):
                saida.append(f"    - Primitiva {j}:")
                attrs = prim.attributes
                if attrs:
                    attr_dict = attrs.__dict__  # <- Acesso seguro e direto
                    for attr_name, accessor_idx in attr_dict.items():
                        if accessor_idx is not None:
                            try:
                                accessor = glb.accessors[int(accessor_idx)]
                                saida.append(f"        ▪ Atributo: {attr_name.upper()} (Accessor {accessor_idx})")
                                saida.append(f"          • Tipo: {accessor.type}, ComponentType: {accessor.componentType}, Count: {accessor.count}")
                                if accessor.min: saida.append(f"          • Mín: {accessor.min}")
                                if accessor.max: saida.append(f"          • Máx: {accessor.max}")
                            except Exception as e:
                                saida.append(f"          [ERRO ao acessar accessor {accessor_idx}: {e}]")
                if prim.indices is not None:
                    try:
                        accessor = glb.accessors[prim.indices]
                        saida.append(f"        ▪ Índices: Accessor {prim.indices}")
                        saida.append(f"          • Count: {accessor.count}, Type: {accessor.type}, Component: {accessor.componentType}")
                    except Exception as e:
                        saida.append(f"          [ERRO ao acessar índices: {e}]")

    if glb.materials:
        saida.append(f"\n🎨 MATERIAIS ({len(glb.materials)}):")
        for i, mat in enumerate(glb.materials):
            saida.append(f"  ▸ Material {i}: {mat.name or '[sem nome]'}")

    if glb.animations:
        saida.append(f"\n🎬 ANIMAÇÕES ({len(glb.animations)}):")
        for i, anim in enumerate(glb.animations):
            saida.append(f"  ▸ Animação {i}")
            for j, channel in enumerate(anim.channels):
                tgt = channel.target
                sampler = anim.samplers[channel.sampler]
                saida.append(f"    - Canal {j}: node {tgt.node}, propriedade {tgt.path}, interpolação: {sampler.interpolation}")

    if glb.accessors:
        saida.append(f"\n📐 ACCESSORS ({len(glb.accessors)}):")
        for i, acc in enumerate(glb.accessors):
            saida.append(f"  ▸ Accessor {i}: Tipo={acc.type}, ComponentType={acc.componentType}, Count={acc.count}")
            if acc.min: saida.append(f"    • Min: {acc.min}")
            if acc.max: saida.append(f"    • Max: {acc.max}")

    return "\n".join(saida)

def extrair_info_glb(caminho_glb):
    try:
        glb = GLTF2().load_binary(caminho_glb)
    except Exception as e:
        return f"[ERRO] Leitura GLB falhou: {e}"

    saida = []
    saida.append(f"🗂️ Arquivo: {os.path.basename(caminho_glb)}")
    saida.append(f"📍 Caminho: {caminho_glb}")
    saida.append(f"📅 Data: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}")
    saida.append("=" * 60)

    if glb.asset:
        saida.append(f"🔖 Versão: {glb.asset.version}")
        if glb.asset.generator:
            saida.append(f"🔧 Gerado por: {glb.asset.generator}")

    saida.append(detalhar_glb(glb))
    return "\n".join(saida)

def salvar_em_txt(texto, nome_arquivo="info_modelo_glb_tudo.txt"):
    try:
        with open(nome_arquivo, "w", encoding="utf-8") as f:
            f.write(texto)
        print(f"\n📁 Arquivo salvo em: {os.path.abspath(nome_arquivo)}")
    except Exception as e:
        print(f"[ERRO] Falha ao salvar: {e}")

def main():
    print("=== 🔎 Leitor Completo de Arquivo GLB ===")
    caminho = input("\n🔍 Caminho do arquivo .glb (ou pressione ENTER para abrir): ").strip().strip('"')

    if not caminho:
        caminho = escolher_arquivo()
        if not caminho:
            print("❌ Nenhum arquivo selecionado.")
            return

    if not os.path.isfile(caminho):
        print(f"❌ Arquivo não encontrado:\n{caminho}")
        return

    if not caminho.lower().endswith(".glb"):
        print(f"❌ O arquivo não é .glb:\n{caminho}")
        return

    print("⏳ Extraindo dados...")
    texto = extrair_info_glb(caminho)
    estrutura = gerar_estrutura_diretorios(os.path.dirname(caminho))
    salvar_em_txt(texto + "\n\n" + estrutura)

if __name__ == "__main__":
    main()
