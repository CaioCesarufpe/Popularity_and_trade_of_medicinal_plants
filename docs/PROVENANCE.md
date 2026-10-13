# Provenance and known limitations

## Data pipeline and counts

| Stage | Counts | Evidence |
|---|---|---|
| Raw scraping (71 search terms) | 43,160 listings (manuscript) | raw spreadsheets, file dates 8 Nov 2024 |
| Manual filtering per spreadsheet | 71 files in `data/raw/ml_sheets/` | file dates 5 Jan 2025 |
| Unified table | 15,166 rows; 10,205 unique (source, ID); 64 search terms | `ml_unified_listings.csv` (file dated 27 Feb 2026) |
| Recategorization and exclusions | about 15,122 rows | Supplementary Script 1 |
| Deduplicated analytical dataset | 10,176 unique listings | manuscript; `scripts/04e_deduplicate_listings.R` |

An earlier version of Supplementary Script 1 reported 15,299 rows for the unified table. The unified file provided here has 15,166 rows;
the 15,122 figure refers to the state after the final recategorization and exclusions.

## Collection dates

Google Trends: 16 March 2024. ANVISA: 20 March 2024. Mercado Livre scraping: 8 November 2024 (from file timestamps).
Manual filtering: 5 January 2025.

## Duplicated listings

The unified table already contains 4,961 repeated (source, ID) rows before any recategorization. Most repeated listings carry different
original Mercado Livre categories (for example Cha and Sem Categoria, or Saude and Suplementos Alimentares), so the same listing was
probably retrieved by searches in more than one category. This explanation was inferred from the data, not from the scraper logs.

## Search terms without listings

Only 64 of the 71 search terms have at least one listing in the unified table; for example, the spreadsheet `arnica-brasileira` contains no rows.
Rankings of most and least advertised species therefore refer to the 64 terms with listings.

## Lost or reconstructed code

- The script that produced `ml_recategorized_en.csv` (first keyword-based recategorization pass, including `TITLE_norm`) was not preserved. The file is
  provided as data and the later steps start from it. The manuscript describes this pass as keyword-based recategorization of listing titles that created the
  category Nutraceuticals and redistributed many listings to Health and Tea.
- The original script of Figs. 5A-C was lost; `scripts/06_time_series_figures.R` reuses the original Fig. 1 script with the same style and a dashed line at Feb 2009.
- The raw scraper output and the manual filtering decisions are not documented row by row.

## Independent check of the time-series results

The ITS results were recomputed independently in Python (statsmodels; OLS with Newey-West lag 4) from `gtrends_monthly_raw.xlsx`. The recomputation
gave 68 analysed species, 35 with a significant change in trend (30 positive, 5 negative) and trend coefficients equal to those in the manuscript
(for example *Glycine max* 1.13, *Bauhinia* spp. -0.67). The R scripts in this repository were not executed in that check.

## Other notes

- Google Trends returns sampled data; repeated collections can differ slightly.
- Species names follow the 2009 RENISUS list, which includes names that are now outdated; see the manuscript Methods and Table S1.
- Mercado Livre listings are public; the tables provided contain no seller personal data. Platform terms apply to the listing content.
