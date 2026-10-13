# Data dictionary

File names refer to the repository layout (see README). Values in Portuguese (species common names, Mercado Livre category names,
listing titles) are data and were kept in the original language. Sections marked *(inferred)* were reconstructed from the scripts.

## data/raw/renisus_knowledge_graph_ids.csv (Table S1 of the manuscript)

| Column | Description |
|---|---|
| gt_column | Column name of the species in `gtrends_monthly_raw.xlsx` (lower-case genus-based code) |
| scientific_name_renisus | Scientific name as written in the official RENISUS list (2009), including synonyms and names that are now outdated. `spp*` marks genera listed without a defined species (the species in parentheses are those named in the list) |
| search_term_pt | Search term used to obtain the Google Knowledge Graph entity (Portuguese common name or scientific name) |
| knowledge_graph_id | Google Knowledge Graph entity ID (e.g. `/m/0h259`) used in Google Trends |

71 rows, one per RENISUS entry.

## data/raw/gtrends_monthly_raw.xlsx

| Column | Description |
|---|---|
| date | First day of the month (YYYY-MM-01), from 2004-01-01 to 2023-12-01 (240 months) |
| 71 species columns | Google Trends relative search index (integer 0-100) for the species entity in Brazil. Each series is scaled so that its own maximum is 100; values are **not comparable across species**. 0 is the lowest search volume of the series |

Column codes follow `gt_column` in `renisus_knowledge_graph_ids.csv`. Two columns were renamed by hand after collection:
`mentha_pulegium` (object `menthapul` in script 02) and `vernonia_condensata` (object `vernoniacon`). Collected on 16 March 2024.
Three series without variation (`cynara`, `solidago`, `tabebuia`) are excluded from the ITS analysis.

## data/processed/its_results_neweywest_full.csv and its_results_classified.csv (produced by script 03)

One row per species with variation (68 rows).

| Column | Description |
|---|---|
| Species | Species column code (as in `gtrends_monthly_raw.xlsx`) |
| Level_Coef, Level_P | Coefficient of `intervention` (immediate level change after Feb 2009) and its Newey-West p-value. Fitted as an adjustment term; not interpreted in the manuscript |
| Trend_Coef, Trend_P | Coefficient of `time_after` (change in monthly slope after Feb 2009; the quantity reported in the manuscript) and its Newey-West p-value |
| DW_stat, DW_p | Durbin-Watson statistic and p-value of the residuals |
| LB_stat, LB_p | Ljung-Box statistic and p-value (lag 12) of the residuals |
| Level_Effect, Trend_Effect | (classified file only) `Positive` / `Negative` if p < 0.05 and the coefficient is > 0 / < 0, otherwise `Non-significant` |

Model: `popularity ~ time + intervention + time_after`; Newey-West lag 4, no prewhitening; time in approximate months (days / 30.44).

## data/processed/ml_unified_listings.csv

Union of the 71 manually filtered per-search-term spreadsheets: 15,166 rows, 10,205 unique (source, ID) pairs, 64 distinct search terms.
The same listing can appear in several rows (it was retrieved under different marketplace categories).

| Column | Type | Description |
|---|---|---|
| source | text | Search term (Portuguese common name) = name of the spreadsheet. Seven of the 71 spreadsheets contain no listings after filtering |
| ID | text | Mercado Livre listing ID (e.g. `MLB3586486453`) |
| TITLE | text | Listing title as published by the seller |
| PERMALINK | text | Public URL of the listing |
| PRICE | number | Listing price in BRL at collection (one missing value). Not analysed in the manuscript because many listings are kits |
| CATEGORY | text | Original Mercado Livre category: Cha (7,123), Sem Categoria (5,399), Suplementos Alimentares (1,093), Saude (985), Jardim e Ar Livre (296), Plantas (142), Sementes (102), Gengibre (15), Especiarias (9), Sementes Agricolas (2) |
| BY_POPULAR_NAME | logical | `TRUE` for 488 rows, empty for the others. Not used in the final analyses (removed in script 04d) |
| Is_Medicinal | logical | Empty in all rows. Not used (removed in script 04d) |

## data/processed/ml_recategorized_en.csv, ml_recategorized_en_final.csv, ml_recategorized_scientific_final.csv *(inferred)*

Successive versions of the listings table after recategorization. Besides the columns above, these files contain:

| Column | Description |
|---|---|
| TITLE_norm | Normalised listing title (matching is case-insensitive in the scripts) |
| CATEGORY_final | Analytical category in English: Tea, Nutraceuticals, Health, Dietary Supplements, Plants, Seeds, Jardim e Ar Livre, Food, Spices (and `To Review` in the intermediate file only) |
| TAXON_MATCH | (script 04d) First scientific name (species or genus) detected in the title; empty if none |
| BY_SCIENTIFIC_NAME | (04d) `TRUE` if a scientific name was detected |
| SCIENTIFIC_MATCH_TYPE | (04d) `species`, `genus` or empty |
| source_status | (04d) Manual classification of the search term: `taxon_source`, `ambiguous_context` or `review_needed` |

Rows may still be duplicated by (source, ID) in these files.

## data/processed/ml_listings_final_deduplicated.csv (produced by script 04e)

Same columns as `ml_recategorized_scientific_final.csv`, keeping the first row per (source, ID): 10,176 unique listings (manuscript).

## data/raw/ANVISA_RESULTS.xlsx

Manual consultation of the ANVISA medicines database on 20 March 2024, one row per RENISUS species (first sheet; the first data row repeats the
header and the last four columns are empty; the scripts read only the first two columns).

| Column | Description |
|---|---|
| Species | RENISUS species name |
| Registry code | `V` = valid registry; `C/V` = at least one valid and at least one cancelled registry; `C` = all registries cancelled; empty = no registry found |

For the analyses, `V` and `C/V` are classified as **valid registry** (28 species, 39.4%); `C` and empty as **no valid registry** (43 species, 60.6%).
Registry status reflects the database on 20 March 2024 and may have changed since.
