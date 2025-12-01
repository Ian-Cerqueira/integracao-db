{{ config(materialized='table') }}

WITH receitas AS (SELECT * FROM {{ ref('int_receitas_transformadas') }}),
tempo AS (SELECT * FROM {{ ref('dim_tempo_dbt') }}),
entidade AS (SELECT * FROM {{ ref('dim_entidade_dbt') }}),
fonte AS (SELECT * FROM {{ ref('dim_fonte_dbt') }}),
origem AS (SELECT * FROM {{ ref('dim_origem_dbt') }})

SELECT
    tempo.id_tempo_sk,
    entidade.id_entidade_sk,
    fonte.id_fonte_sk,
    origem.id_origem_sk,
    base.receita_prevista,
    base.receita_prevista_acrescimo,
    base.receita_prevista_atualizada,
    base.receita_arrecadada
FROM vacinados AS base

LEFT JOIN tempo
    ON base.ano = tempo.ano
    AND base.mes = tempo.mes

LEFT JOIN entidade
    ON base.orgao_nome = entidade.orgao_nome
    AND base.unidade_nome = entidade.unidade_nome

LEFT JOIN fonte
    ON base.fonte_recurso_nome = fonte.fonte_recurso_nome

LEFT JOIN origem
    ON base.categoria_receita_nome = origem.categoria_receita_nome
    AND base.fonte_origem_receita_nome = origem.fonte_origem_receita_nome
    AND base.rubrica_receita_nome = origem.rubrica_receita_nome
    AND base.receita_local_nome = origem.receita_local_nome