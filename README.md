# 📊 Projeto de Integração de Dados - Receitas de Recife

## 📋 Sobre o Projeto

Este projeto implementa um pipeline completo de integração e análise de dados de receitas municipais da cidade do Recife, abrangendo os anos de 2021 a 2023. O objetivo principal é consolidar múltiplos conjuntos de dados em um Data Warehouse modelado em **Esquema Estrela (Star Schema)**, possibilitando análises aprofundadas e geração de insights sobre a arrecadação municipal.

## 🎯 Objetivos

- Integrar e consolidar dados de receitas de três anos consecutivos (2021-2023)
- Criar um Data Warehouse estruturado em Esquema Estrela
- Implementar processos de ETL e ELT para transformação e carga de dados
- Facilitar análises complexas e consultas sobre receitas municipais
- Gerar insights relevantes sobre arrecadação e distribuição de recursos

## 🏗️ Arquitetura do Projeto

### Estrutura de Arquivos

```
projeto-receitas-recife/
│
├── database/
│   ├── docker-compose.yml   
│   └── init.sql                        
│
├── notebooks/
│   ├── data/
│   │   ├── recife-dados-receitas-2021.csv
│   │   ├── recife-dados-receitas-2022.csv
│   │   └── recife-dados-receitas-2023.csv
│   │
│   ├── ELT.ipynb                   
│   └── ETL.ipynb                   
│
├── transformacao_receitas/
│   ├── analises/
│   │   ├── entidade_menor_receita_anual.sql
│   │   ├── origem_recurso_n_vinculado.sql
│   │   └── receita_media_orgaos_anual.sql
│   │
│   └── models/
│       ├── marts/
│       │   ├── dim_tempo_dbt.sql
│       │   ├── dim_entidade_dbt.sql
│       │   ├── dim_classificacao_financeira_dbt.sql
│       │   ├── dim_origem_dbt.sql
│       │   └── fato_receitas_dbt.sql
│       │   └── int_receitas_transformadas.sql
│ 
├── .gitignore
└── README.md
```

## 🗄️ Modelagem do Data Warehouse

### Esquema Estrela (Star Schema)

O projeto implementa um modelo dimensional com as seguintes tabelas:

#### 📊 Tabela Fato
- **fato_receitas**: Contém as métricas de receitas
  - `id_tempo_sk` (FK)
  - `id_entidade_sk` (FK)
  - `id_classificacao_sk` (FK)
  - `id_origem_sk` (FK)
  - `receita_prevista`
  - `receita_prevista_acrescimo`
  - `receita_prevista_atualizada`
  - `receita_arrecadada`

#### 📐 Tabelas Dimensão

1. **dim_tempo**: Dimensão temporal
   - `id_tempo_sk` (PK)
   - `ano`
   - `mes`

2. **dim_entidade**: Órgãos e unidades administrativas
   - `id_entidade_sk` (PK)
   - `orgao_nome`
   - `unidade_nome`

3. **dim_classificacao_financeira**: Classificação de recursos
   - `id_classificacao_sk` (PK)
   - `fonte_recurso_nome`

4. **dim_origem**: Origem e detalhamento das receitas
   - `id_origem_sk` (PK)
   - `categoria_receita_nome`
   - `fonte_origem_receita_nome`
   - `rubrica_receita_nome`
   - `receita_local_nome`

## 🔄 Processos de Integração

### Pipeline ETL (notebooks/ETL.ipynb)

O processo ETL implementa as seguintes etapas:

1. **Extração**:
   - Leitura dos arquivos CSV de 2021, 2022 e 2023
   - Tratamento de encoding e separadores específicos (`;`)
   - Configuração de formato brasileiro para valores monetários

2. **Transformação**:
   - Padronização de tipos de dados
   - Limpeza de valores monetários (conversão de `R$ 1.000,00` para `1000.0`)
   - Simplificação de categorias redundantes:
     - Fontes de recursos não vinculados
     - Operações de crédito
     - Rubricas de receita
   - Remoção de colunas redundantes (`mes_nome`, códigos, etc.)
   - Tratamento de encoding incorreto

3. **Carga**:
   - Criação das 4 tabelas dimensão
   - Criação da tabela fato com chaves estrangeiras
   - Inserção no PostgreSQL (schema `analytics_etl`)

### Pipeline ELT (notebooks/ELT.ipynb)

O processo ELT realiza:

1. **Extração e Carga Raw**:
   - Carregamento direto dos dados brutos no PostgreSQL
   - Criação de tabelas no schema `raw`:
     - `2021_receitas_raw_data`
     - `2022_receitas_raw_data`
     - `2023_receitas_raw_data`

2. **Transformação via DBT** (transformacao_receitas/):
   - Unificação dos três anos em `int_receitas_transformadas`
   - Aplicação de regras de negócio e limpeza
   - Materialização das dimensões (`dim_*`)
   - Criação da tabela fato com relacionamentos

## 🛠️ Tecnologias Utilizadas

- **Python 3.12**: Linguagem principal para processamento
- **Pandas**: Manipulação e análise de dados
- **SQLAlchemy**: ORM e conexão com banco de dados
- **PostgreSQL**: Sistema de gerenciamento de banco de dados
- **DBT (Data Build Tool)**: Transformação de dados no warehouse
- **Jupyter Notebook**: Ambiente de desenvolvimento interativo

## 📦 Dependências

```bash
pip install pandas sqlalchemy psycopg2-binary python-dotenv
```

## ⚙️ Configuração e Instalação

### 1. Configurar o Banco de Dados

Certifique-se de ter o PostgreSQL instalado e em execução.

### 2. Configurar Variáveis de Ambiente

Crie um arquivo `.env` na pasta `database/`:
```env
DB_USER=postgres
DB_PASSWORD=sua_senha
DB_HOST=localhost
DB_PORT=5432
DB_NAME=receitas_recife
```

### 3. Criar Schemas no Banco

Execute os comandos SQL para criar os schemas necessários:
```sql
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics_etl;
```

## 🚀 Como Executar

### Opção 1: Pipeline ETL Completo (Python + Pandas)

1. Navegue até a pasta `notebooks/`
2. Abra o notebook `ETL.ipynb`
3. Execute todas as células sequencialmente
4. Verifique as tabelas criadas:
   ```sql
   SELECT * FROM analytics_etl.dim_tempo LIMIT 5;
   SELECT * FROM analytics_etl.tabela_fato LIMIT 5;
   ```

**Resultado esperado:**
- 4 tabelas dimensão criadas
- 1 tabela fato com 16.621 registros
- Dados consolidados de 2021-2023

### Opção 2: Pipeline ELT (Raw + DBT)

1. **Carregar dados brutos:**
   ```python
   # Execute o notebook ELT.ipynb
   # Cria tabelas no schema 'raw'
   ```

2. **Executar transformações DBT:**
   ```bash
   cd transformacao_receitas
   
   # Executar modelo intermediário
   dbt run --models int_receitas_transformadas
   
   # Executar dimensões
   dbt run --models dim_tempo_dbt dim_entidade_dbt dim_classificacao_financeira_dbt dim_origem_dbt
   
   # Executar fato
   dbt run --models fato_receitas_dbt
   ```

## 📊 Análises Disponíveis

O projeto inclui três análises SQL pré-construídas na pasta `transformacao_receitas/analises/`:

### 1. Entidade com Menor Receita Anual
**Arquivo:** `entidade_menor_receita_anual.sql`

Identifica o órgão municipal com menor arrecadação em cada ano, permitindo identificar áreas que necessitam atenção ou reestruturação orçamentária.

```sql
-- Retorna: orgao_nome, ano, receita_total_anual
```

### 2. Top 10 Origens de Recursos Não Vinculados
**Arquivo:** `origem_recurso_n_vinculado.sql`

Lista as 10 principais rubricas de receitas não vinculadas (recursos livres que podem ser alocados conforme necessidade da administração).

```sql
-- Retorna: rubrica_receita_nome, valor_total_arrecadado_livre
-- Ordenado por valor DESC
```

### 3. Receita Média Anual por Órgão
**Arquivo:** `receita_media_orgaos_anual.sql`

Calcula a média de arrecadação de cada órgão por ano, facilitando comparações de desempenho e tendências ao longo do tempo.

```sql
-- Retorna: orgao_nome, ano, receita_media_anual
-- Ordenado por receita_media_anual DESC
```

**Como executar as análises:**
```sql
-- Conecte-se ao banco PostgreSQL e execute:
\i transformacao_receitas/analises/entidade_menor_receita_anual.sql
```

## 🧹 Tratamentos de Dados Aplicados

### Padronização de Dados

#### Valores Monetários
- **Formato original**: `R$ 22.550.000,00`
- **Formato final**: `22550000.0`
- **Processo**:
  1. Remoção de `R$` e espaços
  2. Remoção de pontos (separador de milhar)
  3. Substituição de vírgula por ponto (decimal)
  4. Conversão para `NUMERIC/FLOAT`

#### Categorias Simplificadas

**Fonte de Recurso:**
```python
# Consolidação de nomenclaturas similares
"RECURSOS ORDINÁRIOS - NÃO VINCULADOS" → "RECURSOS NÃO VINCULADOS"
"RECURSOS NÃO VINCULADOS DE IMPOSTOS" → "RECURSOS NÃO VINCULADOS"
"OUTROS RECURSOS NÃO VINCULADOS" → "RECURSOS NÃO VINCULADOS"

# Operações de crédito unificadas
"OPERAÇÃO DE CRÉDITO - CPAC" → "RECURSOS DE OPERAÇÕES DE CRÉDITO"
"OPERAÇÕES DE CRÉDITO - PMAT" → "RECURSOS DE OPERAÇÕES DE CRÉDITO"
```

**Rubricas de Receita:**
```python
# Correção de encoding
"TRANSFERÊNCIAS DE RECURSOS DO SISTEMA ÚNICO DE SAÚDE ? SUS" 
→ "TRANSFERÊNCIAS DE RECURSOS DO SISTEMA ÚNICO DE SAÚDE - SUS"

# Padronização de nomenclaturas
"CONTRIBUIÇÕES SOCIAIS ESPECÍFICAS DE ESTADOS / DF / MUNICÍPIOS"
→ "CONTRIBUIÇÕES SOCIAIS ESPECÍFICAS DE ESTADOS, DF E MUNICÍPIOS"
```

### Colunas Removidas

Eliminação de informações redundantes ou desnecessárias:
- `mes_nome` (redundante com `mes`)
- `alinea_receita_nome` (especificação excessiva)
- `subalinea_receita_nome` (especificação excessiva)
- Todas as colunas de código (`*_codigo`)

### Tratamento de Nulos

- Verificação de valores nulos em todas as colunas
- Validação de campos obrigatórios
- Conversão segura de tipos com tratamento de exceções

## 📈 Métricas do Projeto

| Métrica | Valor |
|---------|-------|
| **Total de Registros Consolidados** | 16.621 |
| **Período Analisado** | 3 anos (2021-2023) |
| **Tabelas Dimensão** | 4 |
| **Tabela Fato** | 1 |
| **Órgãos Únicos** | 14 |
| **Entidades Únicas (Órgão/Unidade)** | 32 |
| **Fontes de Recurso** | 92 |
| **Classificações de Origem** | 904 |
| **Períodos Temporais** | 36 (3 anos × 12 meses) |

## 📝 Notas Importantes

- Os dados utilizados são **públicos** e disponibilizados pela Prefeitura do Recife
- O projeto utiliza **PostgreSQL** como SGBD principal
- Recomenda-se utilizar dados de **anos consecutivos** para análises temporais coerentes
- O schema `raw` mantém os dados originais **inalterados**
- O schema `analytics_etl` contém os dados **transformados e modelados**
- Valores monetários seguem o padrão brasileiro no CSV (`,` decimal, `.` milhar)

## 📚 Referências

- [Dados Abertos Recife](https://dados.recife.pe.gov.br/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [DBT Documentation](https://docs.getdbt.com/)
- [Pandas Documentation](https://pandas.pydata.org/docs/)

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


---

**Tecnologias:** Python • PostgreSQL • DBT • Pandas • Jupyter

**Período:** 2025.2
