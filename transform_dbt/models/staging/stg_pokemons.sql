SELECT
    id AS pokemon_id,
    LOWER(name) AS pokemon_name,
    height / 10.0 AS height_m,
    weight / 10.0 AS weight_kg,
    base_experience,
    UPPER(LEFT(primary_type, 1)) || LOWER(SUBSTR(primary_type, 2)) AS primary_type
FROM {{ source('raw_data', 'raw_pokemons') }}