# modern-elt-pipeline

Pipeline ELT con datos de la [PokéAPI](https://pokeapi.co/):

1. **Extract/Load** (`extract.py`): descarga los primeros 150 pokemons y los guarda en DuckDB (`data/raw_data.duckdb`, tabla `main.raw_pokemons`).
2. **Transform** (`transform_dbt/`): dbt limpia los datos y construye los modelos en capas:
   - `staging`: `stg_pokemons` y `stg_pokemon_stats` (datos limpios y categoría de experiencia).
   - `marts`: `dim_pokemon_summary` (resumen por tipo) y `fct_pokemon_details` (detalle por Pokémon con métricas de su tipo).

## Estructura

```
.
├── docker-compose.yml   # contenedor de desarrollo (Python 3.11)
├── extract.py           # extracción desde la API y carga en DuckDB
├── requirements.txt     # dependencias de Python
├── data/                # base DuckDB (ignorada por git)
└── transform_dbt/       # proyecto dbt
    ├── profiles.yml     # perfil de dbt (apunta a data/raw_data.duckdb)
    └── models/
        ├── staging/     # source raw_pokemons, stg_pokemons, stg_pokemon_stats
        └── marts/       # dim_pokemon_summary, fct_pokemon_details
```

## Requisitos

- Docker y Docker Compose

## Instalación

Levanta el contenedor e instala las dependencias:

```bash
docker compose up -d
docker exec -it modern_elt_env bash
pip install -r requirements.txt
```

Los comandos siguientes se ejecutan dentro del contenedor. El proyecto está montado en `/workspace`.

## Cómo correrlo

### 1. Extraer los datos

```bash
cd /workspace
python extract.py
```

Crea `data/raw_data.duckdb` con la tabla `raw_pokemons`.

### 2. Transformar con dbt

```bash
cd /workspace/transform_dbt
dbt build
```

`dbt build` construye los 4 modelos y corre los tests definidos en los `_schema.yml` de cada carpeta (documentación y tests). También puedes usar `dbt run` solo para los modelos o `dbt test` solo para los tests.

### 3. Revisar el resultado

```bash
python -c "
import duckdb
con = duckdb.connect('/workspace/data/raw_data.duckdb', read_only=True)
con.sql('select * from main.fct_pokemon_details limit 5').show()
"
```
