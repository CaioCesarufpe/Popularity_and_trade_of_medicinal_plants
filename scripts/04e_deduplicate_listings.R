# =============================================================================
# 04e_deduplicate_listings.R   (helper script)
# Purpose : write the deduplicated analytical dataset used in the manuscript. The same listing can
#           appear in several rows (it was retrieved under different marketplace categories); only
#           the first row per (source, ID) pair is kept, the same operation applied inside
#           05_manuscript_figures.R.
# Input   : data/processed/ml_recategorized_scientific_final.csv
# Output  : data/processed/ml_listings_final_deduplicated.csv
# Check   : the number of unique listings should be 10,176 (manuscript).
# Run from the repository root.
# =============================================================================

library(readr)
library(dplyr)

ml_raw   <- read_csv(file.path("data", "processed", "ml_recategorized_scientific_final.csv"), show_col_types = FALSE)
ml_dedup <- ml_raw %>% distinct(source, ID, .keep_all = TRUE)

cat("Rows before deduplication:", nrow(ml_raw), "\n")
cat("Rows after deduplication:", nrow(ml_dedup), "(manuscript: 10,176)\n")
cat("Duplicate rows removed:", nrow(ml_raw) - nrow(ml_dedup), "\n")

write_csv(ml_dedup, file.path("data", "processed", "ml_listings_final_deduplicated.csv"))
