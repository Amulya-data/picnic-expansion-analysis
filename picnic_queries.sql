-- Picnic expansion project: example SQL queries (SQLite)
-- Usage:  sqlite3 picnic_cities.db < picnic_queries.sql

.headers on
.mode column

-- 1. The five most densely populated cities (dense cities make delivery cheaper)
SELECT city, state, ROUND(density_per_km2) AS density_per_km2
FROM cities
ORDER BY density_per_km2 DESC
LIMIT 5;

-- 2. Comparison of the federal states
SELECT state,
       COUNT(*)                          AS n_cities,
       ROUND(AVG(disposable_income_eur)) AS avg_income_eur,
       ROUND(AVG(density_per_km2))       AS avg_density
FROM cities
GROUP BY state
ORDER BY avg_income_eur DESC;

-- 3. Cities that are both dense and well off
SELECT city, state, ROUND(density_per_km2) AS density_per_km2, disposable_income_eur
FROM cities
WHERE density_per_km2 > 1500 AND disposable_income_eur > 26000
ORDER BY density_per_km2 DESC;

-- 4. The scoring model in SQL: each indicator rescaled to 0..1 (min-max), then weighted
--    Weights: density 35%, income 30%, share aged 25-44 20%, household size 15%
WITH bounds AS (
    SELECT MIN(density_per_km2) AS d_min, MAX(density_per_km2) AS d_max,
           MIN(disposable_income_eur) AS i_min, MAX(disposable_income_eur) AS i_max,
           MIN(share_aged_25_44) AS a_min, MAX(share_aged_25_44) AS a_max,
           MIN(avg_household_size) AS h_min, MAX(avg_household_size) AS h_max
    FROM cities
),
scored AS (
    SELECT c.city, c.state,
           0.35 * (c.density_per_km2 - b.d_min) / (b.d_max - b.d_min)
         + 0.30 * (c.disposable_income_eur - b.i_min) * 1.0 / (b.i_max - b.i_min)
         + 0.20 * (c.share_aged_25_44 - b.a_min) / (b.a_max - b.a_min)
         + 0.15 * (c.avg_household_size - b.h_min) / (b.h_max - b.h_min) AS score
    FROM cities c, bounds b
)
SELECT RANK() OVER (ORDER BY score DESC) AS rank, city, state, ROUND(score, 3) AS score
FROM scored
ORDER BY score DESC
LIMIT 10;
