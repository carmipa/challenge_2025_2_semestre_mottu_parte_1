
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
[![GitHub](https://img.shields.io/badge/GitHub-Repositório-blue?style=flat-square&logo=github)](https://github.com/carmipa/challenge_2025_1_semestre_mottu/tree/main/Mastering_Relational_and_Non_Relational_Database)

---

## 🎨 **Tecnologias Utilizadas**
![Oracle Database](https://img.shields.io/badge/Oracle-Database-red?style=flat-square&logo=oracle)  
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-F80000?style=flat-square&logo=oracle)  
![Data Modeler](https://img.shields.io/badge/Oracle-Data%20Modeler-006600?style=flat-square&logo=oracle)  
![JSON](https://img.shields.io/badge/JSON-000000?style=flat-square&logo=json)  
