# Where should Picnic expand next in Germany?

A small data project that ranks 30 large German cities (more than 100,000 residents) where Picnic did not deliver yet (as of October 2026), to find the most promising places for expansion.

## Result

| Rank | City | Score (0-1) |
| --- | --- | --- |
| 1 | Frankfurt am Main | 0.79 |
| 2 | Fürth | 0.68 |
| 3 | Mainz | 0.60 |
| 4 | Ulm | 0.60 |

Frankfurt and Fürth stayed in the top 3 under all five weightings I tested. Leaving out the five cities with district-level data did not change the top five.

## Method

Each city gets one score from four indicators. Every indicator is rescaled to 0-1 (lowest city = 0, highest = 1) and multiplied by a weight:

| Indicator | Weight | Why |
| --- | --- | --- |
| Population density (people per km²) | 35% | Delivery vans run fixed routes, so customers close together lower the cost per order |
| Disposable income per person | 30% | Spending power for groceries |
| Share of residents aged 25-44 | 20% | Age group most used to ordering groceries on an app |
| Average household size | 15% | Larger households place bigger orders; the weakest signal |

The weights are my own assumptions, not measured effects. To check how much they matter, I ran five different weightings (density focus, income focus, equal weights, families focus) and counted which cities stay in the top 3.

## Data

| Data | Source | Year |
| --- | --- | --- |
| Population, area | Wikipedia, List of cities in Germany by population | 31 Dec 2021 |
| Disposable income per person | Statistikportal, VGR der Länder (Einkommen Kreise) | 2023 |
| Average household size | Zensus 2022 database, table 5000H-0001 | 15 May 2022 |
| Population aged 25-44 | Wegweiser Kommune (Bertelsmann Stiftung) | 2023 (2021 for five cities) |
| Cities Picnic already serves | picnic.app/de/locations | October 2026 |

Sources are also listed per city in the `notes_source` column.

## Limits

- The data years are mixed (see table above).
- The age band is 25-44, because the source has no 25-55 band.
- Income and household size for Reutlingen, Göttingen, Bergisch Gladbach, Recklinghausen and Saarbrücken are district values, not city values.
- The model has no data on delivery costs, competitors or local demand. It is a first screen, not a decision.

## Files

- `Picnic_Expansion_Data_Table_final.xlsx`: the data table (30 cities, 5 indicators)
- `picnic_cities.sql`: creates the SQLite database from the table
- `picnic_queries.sql`: example SQL queries, including the scoring model written in SQL
- `picnic_cities.db`: the finished SQLite database
- `Picnic_Expansion_Analysis_Part2_clean.ipynb`: Python notebook with the SQL queries, scoring, chart and sensitivity check

To rebuild the database: `sqlite3 picnic_cities.db < picnic_cities.sql`, then `sqlite3 picnic_cities.db < picnic_queries.sql`.

## How this project was made

I chose the question and the indicators, collected the data from the sources above (including the Zensus export and the age counts from Wegweiser Kommune), and checked selected values against the portals. The Python and SQL code was written with AI assistance (Claude), and I am learning to rebuild and extend it myself.
