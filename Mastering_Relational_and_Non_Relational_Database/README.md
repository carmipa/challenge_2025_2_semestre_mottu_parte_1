# 💾 **Mastering Relational and Non-Relational Database**

## 🔶 **Descrição**
O desafio consiste em desenvolver **procedimentos, funções e triggers** em **Oracle PL/SQL**, com foco em lógica procedural estruturada, manipulação de dados relacionais e boas práticas de documentação.  

📌 **Entrega: 3º Sprint**

---

## 📋 **Requisitos da Atividade**
- **02 Procedimentos**  
- **02 Funções**  
- **01 Trigger (Gatilho)**  
- Scripts completos de **estrutura e carga de dados**.  
- **Documentação técnica** em **PDF** e **SQL**, incluindo prints de execução e tratamento de exceções.  

### 🔹 Foco do Trabalho
- Desenvolver **lógica procedural** em PL/SQL.  
- Manipular dados relacionais e **converter em JSON manualmente** (sem funções automáticas).  
- Implementar **auditoria via Trigger**.  
- Aplicar **boas práticas de documentação, tratamento de erros e organização de código**.  

---

## 📑 **Especificações Técnicas**
### 🔹 Procedimentos (30 pts)
**Procedimento 1:**  
- Realizar **JOIN entre 2+ tabelas** relacionais.  
- Exibir resultado em **formato JSON (string)**.  
- Conversão deve ser feita manualmente por **Função 1**.  
- Cada tabela deve conter no mínimo **5 registros válidos**.  
- Tratar pelo menos **3 exceções** com `EXCEPTION WHEN`.  

**Procedimento 2:**  
- Ler dados de uma tabela de fatos (ex.: **agencia, conta, saldo**).  
- Calcular e exibir:  
  - Valores somados por **agencia+conta**.  
  - **Subtotal** por agência.  
  - **Total geral**.  
- Somatória feita **manualmente no corpo do procedimento** (sem ROLLUP, CUBE, GROUPING SETS).  
- Saída deve seguir o formato de agrupamento, exemplo:  



Agencia Conta Saldo

1 1 4363.55
1 2 4794.76
...
Sub Total 24291.35
2 1 5652.84
...
Sub Total 26237.04
Total Geral 50528.39

- Tratar pelo menos **3 exceções distintas**.  
- Tabela deve conter ao menos **5 registros detalhados**.  

---

### 🔹 Funções (30 pts)
**Função 1:**  
- Receber dados relacionais e retornar em **JSON (string)**.  
- Conversão deve ser manual (sem `TO_JSON`, `JSON_OBJECT`, etc.).  
- Tratar pelo menos **3 exceções distintas**.  

**Função 2:**  
- Substituir algum processo lógico do projeto (ex.: **validação de senha, cálculos matemáticos, verificação de limites**).  
- Tratar pelo menos **3 exceções distintas**.  

---

### 🔹 Trigger (30 pts)
**Trigger de Auditoria (DML):**  
- Criar tabela de auditoria com campos:  
  - Nome do usuário.  
  - Tipo da operação (**INSERT, UPDATE, DELETE**).  
  - Data e hora da operação.  
  - Valores anteriores (`:OLD`) e valores novos (`:NEW`).  
- Criar trigger `AFTER INSERT OR UPDATE OR DELETE` para registrar auditoria.  

---

## 📦 **Entrega e Documentação (10 pts)**
### 🔹 Arquivo PDF
`2TDSX_2024_Proj_BD.pdf` com:  
- Capa (nomes completos e RMs dos integrantes).  
- Prints da execução de **procedimentos, funções e trigger**.  
- Evidência de exceções tratadas.  
- Código comentado e organizado.  
- Código corrigido com base no feedback da 2ª Sprint.  

### 🔹 Arquivo SQL
`2TDSX_2024_CodigoSql_Integrantes.sql` com:  
- **CREATE TABLE** de todas as tabelas.  
- **INSERT INTO** (mínimo 5 registros por tabela).  
- Procedimentos (`CREATE OR REPLACE PROCEDURE`).  
- Funções (`CREATE OR REPLACE FUNCTION`).  
- Trigger de auditoria.  
- Comentários explicativos no código.  

---

## ⚠️ **Infrações e Penalidades**
| Infração | Desconto |
|----------|----------|
| Uso de funções built-in JSON (`TO_JSON`, `JSON_OBJECT`, etc.) | -10 pts por ocorrência |
| Falta de tratamento de exceções | -5 pts por item |
| Ausência de prints de exceções tratadas | -5 pts por item |
| Código sem comentários ou desorganizado | -5 pts |
| Tabelas com menos de 5 registros | -5 pts por tabela |
| Trigger incompleta/não funcional | -10 pts |
| Falta de documentação mínima (sem capa, prints, explicação clara) | -5 a -10 pts |
| Não entregar arquivo `.sql` completo | -10 pts |

---

## 📂 **Link do Repositório**
[![GitHub](https://img.shields.io/badge/GitHub-Repositório-blue?style=flat-square&logo=github)](https://github.com/carmipa/challenge_2025_2_semestre_mottu_parte_1/tree/main/Mastering_Relational_and_Non_Relational_Database)

---

## 🎨 **Tecnologias Utilizadas**
![Oracle Database](https://img.shields.io/badge/Oracle-Database-red?style=flat-square&logo=oracle)  
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-F80000?style=flat-square&logo=oracle)  
![Data Modeler](https://img.shields.io/badge/Oracle-Data%20Modeler-006600?style=flat-square&logo=oracle)  
![JSON](https://img.shields.io/badge/JSON-000000?style=flat-square&logo=json)  
