# 🛠️ Sistema Híbrido de Rastreamento e Gestão de Motocicletas em Pátios

Com base nas informações fornecidas, foi desenhado um **modelo de banco de dados relacional** para o sistema, utilizando **Oracle** como SGBD. A ideia é criar um *breakstore* (visão geral) onde você possa visualizar as principais entidades e seus relacionamentos.

---

## 🏷️ Entidades Principais

| Ícone | Entidade                   | Descrição                                                      |
| :---: | :------------------------- | :------------------------------------------------------------- |
|   🏍️   | **Motocicletas**           | Armazena os dados das motocicletas registradas no sistema.     |
|   🏢   | **Pátios**                 | Registra as informações dos pátios onde as motocicletas ficam. |
|   📍   | **Zonas**                  | Áreas dentro de cada pátio onde as motos estão localizadas.    |
|   📦   | **Boxes**                  | Localizações exatas (slots) dentro das zonas.                  |
|   📡   | **Rastreadores GPS**       | Informações sobre rastreadores GPS instalados nas motos.       |
|   📶   | **Rastreadores BLE**       | Informações sobre rastreadores BLE de proximidade.             |
|   🕒   | **Eventos de Localização** | Registros de movimentação/localização em tempo real.           |
|   👤   | **Usuários**               | Dados de administração, operadores e técnicos.                 |
|   🏬   | **Filiais**                | Informações sobre as filiais que possuem pátios e usuários.    |

---

## 💾 Modelo Relacional Proposto

> **Observação:** todos os `INT` devem ser adequados ao tipo equivalente do Oracle (ex.: `NUMBER`, `INTEGER`), conforme sua convenção.

### 1. `motocicletas`
```sql
CREATE TABLE motocicletas (
    id_moto      INT         PRIMARY KEY,
    placa        VARCHAR2(10) NOT NULL,
    modelo       VARCHAR2(50),
    ano          INT,
    status       VARCHAR2(20),
    id_patio     INT,
    id_box       INT,
    FOREIGN KEY (id_patio) REFERENCES patios(id_patio),
    FOREIGN KEY (id_box)   REFERENCES boxes(id_box)
);

---

### 2. `patios`
```sql
CREATE TABLE patios (
    id_patio  INT          PRIMARY KEY,
    nome      VARCHAR2(50),
    endereco  VARCHAR2(100),
    id_filial INT,
    FOREIGN KEY (id_filial) REFERENCES filiais(id_filial)
);

---

### 2. `zonas`
```sql
CREATE TABLE zonas (
    id_zona  INT          PRIMARY KEY,
    nome     VARCHAR2(50),
    id_patio INT,
    FOREIGN KEY (id_patio) REFERENCES patios(id_patio)
);

---

### 2. `boxes`
```sql
CREATE TABLE boxes (
    id_box  INT          PRIMARY KEY,
    nome    VARCHAR2(50),
    id_zona INT,
    FOREIGN KEY (id_zona) REFERENCES zonas(id_zona)
);

---

### 2. `rastreadores_gps`
```sql
CREATE TABLE rastreadores_gps (
    id_rastreador INT          PRIMARY KEY,
    id_moto       INT,
    imei          VARCHAR2(20),
    status        VARCHAR2(20),
    FOREIGN KEY (id_moto) REFERENCES motocicletas(id_moto)
);

---

### 2. `rastreadores_ble`
```sql
CREATE TABLE rastreadores_ble (
    id_rastreador INT          PRIMARY KEY,
    id_moto       INT,
    uuid          VARCHAR2(50),
    status        VARCHAR2(20),
    FOREIGN KEY (id_moto) REFERENCES motocicletas(id_moto)
);

---

### 2. `eventos_localizacao`
```sql
CREATE TABLE eventos_localizacao (
    id_evento   INT           PRIMARY KEY,
    id_moto     INT,
    data_evento TIMESTAMP,
    tipo_evento VARCHAR2(50),
    descricao   VARCHAR2(255),
    id_zona     INT,
    id_box      INT,
    FOREIGN KEY (id_moto) REFERENCES motocicletas(id_moto),
    FOREIGN KEY (id_zona) REFERENCES zonas(id_zona),
    FOREIGN KEY (id_box)  REFERENCES boxes(id_box)
);

---

### 2. `usuarios`
```sql
CREATE TABLE usuarios (
    id_usuario INT           PRIMARY KEY,
    nome       VARCHAR2(100),
    email      VARCHAR2(100),
    senha      VARCHAR2(100),
    id_filial  INT,
    FOREIGN KEY (id_filial) REFERENCES filiais(id_filial)
);

---

### 2. `filiais`
```sql

CREATE TABLE filiais (
    id_filial INT            PRIMARY KEY,
    nome      VARCHAR2(100),
    endereco  VARCHAR2(200)
);
---

## Relacionamentos entre as Tabelas

### *Motocicletas estão relacionadas a Pátios e Boxes.

### *Patios estão relacionados a Zonas e a Filiais.

### *Zonas estão relacionadas a Boxes.

### *Rastreadores GPS e BLE estão associados a Motocicletas.

### *Eventos de Localização estão registrados por Moto e associados a Zona e Box.

---

# Desenho do Relacionamento - Diagrama de Relacionamento entre Entidades

+-------------------+      +-------------------+       +-----------------+
|     filiais       |      |     patios        |       |   motocicletas  |
+-------------------+      +-------------------+       +-----------------+
| id_filial (PK)    |<---->| id_patio (PK)     |<----->| id_moto (PK)    |
| nome              |      | nome              |       | placa           |
| endereco          |      | endereco          |       | modelo          |
+-------------------+      | id_filial (FK)    |       | ano             |
                           +-------------------+       | status          |
                                                      +-----------------+

+-------------------+      +-------------------+      +-------------------+
|      zonas        |<---->|     boxes         |      | rastreadores_gps  |
+-------------------+      +-------------------+      +-------------------+
| id_zona (PK)      |      | id_box (PK)       |<---->| id_rastreador (PK)|
| nome              |      | nome              |      | id_moto (FK)      |
| id_patio (FK)     |      | id_zona (FK)      |      | imei              |
+-------------------+      +-------------------+      | status            |
                                                      +-------------------+

+-----------------------+
| eventos_localizacao   |
+-----------------------+
| id_evento (PK)        |
| id_moto (FK)          |
| data_evento           |
| tipo_evento           |
| descricao             |
| id_zona (FK)          |
| id_box (FK)           |
+-----------------------+

---

# * Considerações *
## Ícones e cores: 
### Para os ícones, podemos usar algo que remeta ao setor de logística, como setas, carros, motocicletas, etc., e ### utilizar a ### paleta de cores que remeta ao sistema Radar Motu. Cores como verde e preto seriam apropriadas.

## Desenho de Relacionamento: 
### O diagrama mostra como as tabelas se interconectam. Cada entidade pode ter múltiplos registros ### relacionados a ela (um para ### muitos), como no caso de motocicletas que podem ter vários eventos ou rastreadores.

# * Como Usar Este Banco de Dados *
## Adicionar Novas Motos: 
### Registre as motos na tabela motocicletas com seus dados.

## Localização das Motos: 
### Use os rastreadores GPS e BLE para atualizar a localização na tabela eventos_localizacao.

## Gerenciamento de Pátios:
### Modifique os pátios e zonas usando o sistema web para que o administrador possa configurar as áreas de estacionamento das motos.

