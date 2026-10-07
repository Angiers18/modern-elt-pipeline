import os
import duckdb
import pandas as pd
import requests

# URL de la API de Pokémon (primeros 150)
url = "https://pokeapi.co/api/v2/pokemon?limit=150"

print("📥 Extrayendo datos de la API de Pokémon...")
response = requests.get(url)
data = response.json()["results"]

pokemon_list = []
for item in data:
  detail_res = requests.get(item["url"]).json()
  pokemon_list.append({
      "id": detail_res["id"],
      "name": detail_res["name"],
      "height": detail_res["height"],
      "weight": detail_res["weight"],
      "base_experience": detail_res["base_experience"],
      "primary_type": detail_res["types"][0]["type"]["name"],
  })

print(f"✅ Se obtuvieron {len(pokemon_list)} registros correctamente.")

# Convertimos la lista de diccionarios en un DataFrame de Pandas
df = pd.DataFrame(pokemon_list)

# Nos aseguramos de que la carpeta 'data' exista
os.makedirs("data", exist_ok=True)

# Guardar en DuckDB local dentro de la carpeta data/ usando Pandas
con = duckdb.connect("data/raw_data.duckdb")
con.execute("CREATE OR REPLACE TABLE raw_pokemons AS SELECT * FROM df")
print(
    "💾 Datos guardados exitosamente en DuckDB (tabla: raw_pokemons) en"
    " data/raw_data.duckdb"
)
con.close()