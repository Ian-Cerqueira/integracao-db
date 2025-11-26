# Projeto de Integração de Dados - Receitas de Recife

**Disciplina:** Banco de Dados  
**Grupo:** 5

## 📋 Sobre o Projeto

Este projeto tem como objetivo realizar a extração, transformação e carregamento (ETL) de dados públicos sobre as receitas municipais da cidade de Recife, referentes aos anos de 2021, 2022 e 2023. Os dados são processados e organizados em um banco de dados PostgreSQL seguindo o modelo dimensional (esquema estrela).

## 🎯 Objetivos

- Consolidar dados de receitas municipais de múltiplos anos
- Realizar limpeza e padronização dos dados
- Estruturar os dados em modelo dimensional para facilitar análises
- Armazenar os dados em um banco de dados PostgreSQL

## 🗂️ Estrutura do Projeto

```
projeto-receitas-recife/
├── data/
│   ├── recife-dados-receitas-2021.csv
│   ├── recife-dados-receitas-2022.csv
│   └── recife-dados-receitas-2023.csv
├── database/
│   └── .env
├── ELT.ipynb
├── ETL.ipynb
└── README.md
```

## 🛠️ Tecnologias Utilizadas

- **Python 3.13+**
- **Pandas** - Manipulação e análise de dados
- **SQLAlchemy** - ORM e conexão com banco de dados
- **PostgreSQL** - Banco de dados relacional
- **psycopg2-binary** - Driver PostgreSQL para Python
- **python-dotenv** - Gerenciamento de variáveis de ambiente
- **Jupyter Notebook** - Ambiente de desenvolvimento

## 📊 Modelo de Dados

O projeto implementa um **esquema estrela** com as seguintes dimensões:

### Dimensões

1. **dim_tempo**
   - id_tempo_sk (PK)
   - ano
   - mes

2. **dim_entidade**
   - id_entidade_sk (PK)
   - orgao_nome
   - unidade_nome

3. **dim_fonte**
   - id_fonte_sk (PK)
   - fonte_recurso_codigo
   - fonte_recurso_nome
   - fonte_origem_receita_codigo
   - fonte_origem_receita_nome

4. **dim_descricao**
   - id_descricao_sk (PK)
   - categoria_receita_codigo
   - categoria_receita_nome
   - rubrica_receita_codigo
   - rubrica_receita_nome
   - receita_local_codigo
   - receita_local_nome

### Fato

**fato_receitas**
- id_tempo_sk (FK)
- id_entidade_sk (FK)
- id_fonte_sk (FK)
- id_descricao_sk (FK)
- receita_prevista
- receita_prevista_acrescimo
- receita_prevista_atualizada
- receita_arrecadada

## 🚀 Como Executar

### Pré-requisitos

1. Python 3.13 ou superior instalado
2. PostgreSQL instalado e rodando
3. Jupyter Notebook instalado

### Instalação

1. Clone o repositório
```bash
git clone <url-do-repositorio>
cd projeto-receitas-recife
```

2. Instale as dependências
```bash
pip install pandas sqlalchemy psycopg2-binary python-dotenv
```

3. Configure as variáveis de ambiente

Crie um arquivo `.env` na pasta `database/` com as seguintes informações:

```env
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
DB_HOST=localhost
DB_PORT=5432
DB_NAME=receitas_recife
```

### Execução

1. Abra o Jupyter Notebook
```bash
jupyter notebook
```

2. Execute o notebook **ELT.ipynb** para:
   - Carregar os dados brutos no banco de dados
   - Criar as tabelas raw_data

3. Execute o notebook **ETL.ipynb** para:
   - Extrair e consolidar dados dos 3 anos
   - Realizar limpeza e transformações
   - Criar o modelo dimensional
   - Carregar os dados no PostgreSQL

## 📈 Processo ETL

### 1. Extração (Extract)
- Leitura dos arquivos CSV de 2021, 2022 e 2023
- Consolidação dos dados em um único DataFrame
- Total de **16.621 registros** extraídos

### 2. Transformação (Transform)
- Limpeza de valores monetários (conversão de formato brasileiro para float)
- Tratamento de valores nulos
- Remoção de colunas redundantes:
  - mes_nome
  - alinea_receita_codigo e alinea_receita_nome
  - subalinea_receita_codigo e subalinea_receita_nome
  - fonte_origem_receita_codigo e fonte_origem_receita_nome (substituídas por subfonte)
- Criação de dimensões únicas

### 3. Carregamento (Load)
- Criação das tabelas dimensionais
- Inserção dos dados no PostgreSQL
- Criação de chaves substitutas (surrogate keys)

## 📝 Tabelas Dimensões

### Tempo
- ano, mes

### Entidade
- orgao_nome
- unidade_nome

### Fonte
- fonte_recurso_codigo, fonte_recurso_nome
- fonte_origem_receita_codigo, fonte_origem_receita_nome

### Descrição
- categoria_receita_codigo, categoria_receita_nome
- rubrica_receita_codigo, rubrica_receita_nome
- receita_local_codigo, receita_local_nome

### Valores
- receita_prevista
- receita_prevista_acrescimo
- receita_prevista_atualizada
- receita_arrecadada

## 👥 Equipe

**Grupo 5** - Projeto Banco de Dados

| Nome | Login |
|------|-------|
| Arthur Fernandes | `afol` |
| Arthur Torres | `atl` |
| Gabriel Rio | `grtc` |
| Ian Cerqueira | `idhac` |
| Italo Cauã | `icbo` |
| Jésper Ian | `jisbra` |
| Maia | `maf5` |
| Thiago Alves | `tam6` |


## 📄 Licença

Este projeto é desenvolvido para fins acadêmicos na disciplina de Banco de Dados.
