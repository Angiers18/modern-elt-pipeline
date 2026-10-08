# modern-elt-pipeline

Pipeline ELT con datos de la [PokéAPI](https://pokeapi.co/):

1. **Extract/Load** (`extract.py`): descarga los primeros 150 pokemons y los guarda en DuckDB (`data/raw_data.duckdb`, tabla `main.raw_pokemons`).
2. **Transform** (`transform_dbt/`): dbt limpia los datos y crea el modelo `main.stg_pokemons`.

## Estructura

```
.
├── docker-compose.yml   # contenedor de desarrollo (Python 3.11)
├── extract.py           # extracción desde la API y carga en DuckDB
├── requirements.txt     # dependencias de Python
├── data/                # base DuckDB (ignorada por git)
└── transform_dbt/       # proyecto dbt
    ├── profiles.yml     # perfil de dbt (apunta a data/raw_data.duckdb)
    └── models/staging/  # source raw_pokemons y modelo stg_pokemons
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
dbt run
```

### 3. Revisar el resultado

```bash
python -c "
import duckdb
con = duckdb.connect('/workspace/data/raw_data.duckdb', read_only=True)
con.sql('select * from main.stg_pokemons limit 5').show()
"
```
