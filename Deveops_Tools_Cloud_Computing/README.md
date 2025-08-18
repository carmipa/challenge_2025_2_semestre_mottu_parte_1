# ☁️ **DevOps Tools & Cloud Computing**

## 🔶 **Objetivo**
Nesta Sprint, a equipe deve implementar uma solução baseada em uma das disciplinas:  
- **Java Advanced** ou  
- **Advanced Business Development with .NET**  

A aplicação deve estar integrada a um **banco de dados na nuvem**, com deploy utilizando recursos da **Azure**.

---

## ⚙️ **Opções de Implementação (3º Sprint)**
### 🔹 Opção 1: **ACR + ACI**
- Usar **Azure Container Registry (ACR)** para armazenar a imagem Docker.  
- Executar a aplicação em **Azure Container Instance (ACI)**.  
- Ambos obrigatórios.  

### 🔹 Opção 2: **App Service (PaaS)**
- Publicar a aplicação em um **App Service** na Azure.  
- Banco de dados também hospedado na nuvem.  

---

## 📋 **Requisitos Obrigatórios**
1. **Descrição da Solução**: explicação breve do que a aplicação faz.  
2. **Descrição dos Benefícios para o Negócio**: quais problemas resolve ou melhorias que traz.  
3. **Banco de Dados em Nuvem (obrigatório)**:  
   - ❌ Não aceitos: H2 e Oracle da FIAP.  
   - ✅ Aceitos: Oracle (OCI Container), MySQL, Azure SQL, PostgreSQL, MongoDB etc.  
4. **CRUD Completo**: inclusão, alteração, exclusão e consulta em pelo menos uma tabela.  
5. **Inserção e manipulação de pelo menos 2 registros reais** na tabela.  
6. **Código-fonte publicado no GitHub**.  
7. **Arquivo PDF** contendo:  
   - Nome completo e RM dos integrantes.  
   - Link do repositório GitHub.  
   - Link do vídeo no YouTube.  

---

## 📑 **Requisitos Específicos**
### 🔹 Caso escolha **ACR + ACI**
- Usar apenas **imagens oficiais** (Docker Hub, Azure, OCI, AWS etc.).  
- Container **não pode rodar como root/admin**.  
- Pode usar **Dockerfile** ou **Docker Compose**.  
- Entregar scripts de build e execução:  
  - `Dockerfile`, `docker-compose.yml` (se aplicável).  
  - Comandos utilizados (`docker build`, `docker push`, `docker run`).  

### 🔹 Caso escolha **App Service**
- Todos os recursos devem ser criados via **Azure CLI**.  
- Entregar scripts de criação:  
  - Grupo de recurso, Plano do serviço, Serviço de aplicativo, Banco de dados, Configurações adicionais.  

---

## 📊 **Critérios de Avaliação (3º Sprint)**
1. **Arquitetura da Solução** → desenho com fluxos, recursos e explicação (até **10 pts**).  
2. **DDL das Tabelas** → arquivo `script_bd.sql` com estrutura e comentários (até **10 pts**).  
3. **Repositório GitHub separado** → com README.md completo, instruções de deploy e testes (até **10 pts**).  
4. **Vídeo demonstrativo da solução** → mínimo 720p, áudio claro, explicação falada, mostrando:  
   - Deploy da aplicação conforme README.  
   - Criação e configuração do App/BD na nuvem.  
   - Testes de CRUD completos (**inserção, atualização, exclusão, consulta**).  
   - Integração 100% funcional entre App e BD. (**até 70 pts**).  

---

## ⚠️ **Penalidades**
- Sem descrição da solução → **-10 pts**  
- Sem benefício para o negócio → **-10 pts**  
- Falta de itens obrigatórios (3, 4 ou 5) → **-40 pts**  
- Sem repositório separado → **-10 pts**  
- Sem código-fonte → **-40 pts**  
- Sem PDF com nomes/RM e links → **Nota Zero**  

🔹 **ACR + ACI**  
- Sem imagem oficial → **-15 pts**  
- Container rodando como admin → **-10 pts**  
- Script faltando → **-10 pts cada**  
- Sem README de deploy/testes → **-30 pts**  
- Sem evidência CRUD no vídeo → **-30 pts**  
- Vídeo ruim (baixa qualidade/sem áudio falado) → **-30 pts**  

🔹 **App Service**  
- Recursos não criados via CLI → **-30 pts**  
- Script faltando → **-10 pts cada**  

---

## 📂 **Links**
[![Azure Docs](https://img.shields.io/badge/Azure-CLI%20%26%20Cloud%20Docs-blue?style=flat-square&logo=microsoftazure)](https://docs.microsoft.com/en-us/azure/devops/)  
[![GitHub](https://img.shields.io/badge/GitHub-Repositório-blue?style=flat-square&logo=github)](https://github.com/carmipa/challenge_2025_1_semestre_mottu/tree/main/DevOps_Tools_Cloud_Computing)  

---

## 🎨 **Tecnologias Utilizadas**
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker)  
![Azure](https://img.shields.io/badge/Azure-0089D6?style=flat-square&logo=microsoftazure)  
![Azure CLI](https://img.shields.io/badge/Azure%20CLI-0078D4?style=flat-square&logo=powershell)  
![Azure Container Registry](https://img.shields.io/badge/Azure%20ACR-2560E0?style=flat-square&logo=microsoftazure)  
![Azure App Service](https://img.shields.io/badge/Azure%20App%20Service-0078D7?style=flat-square&logo=windows)  
