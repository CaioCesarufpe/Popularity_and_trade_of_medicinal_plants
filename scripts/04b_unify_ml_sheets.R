# =============================================================================
# 04b_unify_ml_sheets.R
# Purpose : unify the 71 per-species Mercado Livre spreadsheets (one .xlsx per RENISUS
#           search term, produced by the scraper in 04a and then filtered manually) into one file.
# Input   : data/raw/ml_sheets/*.xlsx  (file name = species search term, stored in the column `source`)
# Output  : data/processed/ml_unified_listings.csv
# Run from the repository root.
# =============================================================================

library(readxl)
library(dplyr)
library(purrr)

sheets_dir <- file.path("data", "raw", "ml_sheets")
out_file   <- file.path("data", "processed", "ml_unified_listings.csv")
dir.create(dirname(out_file), recursive = TRUE, showWarnings = FALSE)

files <- list.files(path = sheets_dir, pattern = "\\.xlsx$", full.names = TRUE)
if (length(files) == 0) stop("No .xlsx files found in ", sheets_dir)

# Read one file, forcing all columns to text, and add the species search term as `source`
read_sheet_safe <- function(path) {
  source_name <- tools::file_path_sans_ext(basename(path))
  df <- read_excel(path, col_types = "text")
  df %>% mutate(source = source_name, .before = 1)
}

combined <- map_dfr(files, read_sheet_safe)

if ("PRICE" %in% colnames(combined)) {
  combined <- combined %>% mutate(PRICE = as.numeric(PRICE))
}
if ("BY_POPULAR_NAME" %in% colnames(combined)) {
  combined <- combined %>% mutate(BY_POPULAR_NAME = as.logical(as.numeric(BY_POPULAR_NAME)))
}
if ("Is_Medicinal" %in% colnames(combined)) {
  combined <- combined %>% mutate(Is_Medicinal = as.logical(as.numeric(Is_Medicinal)))
}

glimpse(combined)
write.csv(combined, file = out_file, row.names = FALSE, fileEncoding = "UTF-8")
cat("Files unified successfully. Total rows:", nrow(combined), "\n")
