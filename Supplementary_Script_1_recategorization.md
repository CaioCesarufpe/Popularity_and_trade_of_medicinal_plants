# Supplementary Script 1 - Recategorization of Uncategorized Advertisements

This document provides the consolidated R script used to recategorize advertisements originally labeled as `Sem Categoria` ("uncategorized" in Mercado Livre) into English-language analytical categories. The workflow includes removal of non-relevant items, keyword-based reassignment of ambiguous records, exclusion of non-target products, and final export of the cleaned analytical dataset.

## Consolidated R script

```r
library(dplyr)
library(readr)
library(stringr)

# ------------------------------------------------------------
# Run from the repository root.

# 1) Read the recategorized dataset with translated categories
#    (ml_recategorized_en.csv contains TITLE_norm, a normalised title, and CATEGORY_final, the category after the first
#     recategorization pass. The script that created that first file was not preserved: see docs/PROVENANCE.md.)
# ------------------------------------------------------------
input_file  <- file.path("data", "processed", "ml_recategorized_en.csv")
output_file <- file.path("data", "processed", "ml_recategorized_en_final.csv")

df <- read_csv(input_file, show_col_types = FALSE)

# ------------------------------------------------------------
# 2) Remove non-relevant beverage/alcohol items
#    (e.g., liqueurs and similar products)
# ------------------------------------------------------------
df <- df %>%
  filter(!str_detect(str_to_lower(TITLE_norm), "licor|cura[cç]au|absinto|marula"))

# ------------------------------------------------------------
# 3) Reclassify the records initially labeled as "To Review"
#    using keyword-based rules
# ------------------------------------------------------------
df <- df %>%
  mutate(
    title_l = str_to_lower(TITLE_norm),
    CATEGORY_final = case_when(
      CATEGORY_final != "To Review" ~ CATEGORY_final,

      # Medicinal / health-related products
      str_detect(title_l, "hemocura|hepatox|rem[eé]dio|parar de fumar|sabonete|pomada|curativo|onico|micose|antipulgas|antissept|antissépt") ~ "Health",

      # Food products
      str_detect(title_l, "alho|goiabada|chorizo|sal de cura") ~ "Food",

      # Tea products
      str_detect(title_l, "kombucha") ~ "Nutraceuticals",
      str_detect(title_l, "\\b(ch[aá]|tea)\\b") ~ "Tea",

      # Nutraceutical / functional products
      str_detect(title_l, "fitoter|funcional|capsul|c[aá]psul|gotas|xarope|extrato|comprim|s[ée]rum|syrup") ~ "Nutraceuticals",
      str_detect(title_l, "a[cç]afr[aã]o|c[uú]rcuma|turmeric|gengibre|ginger") ~ "Nutraceuticals",
      str_detect(title_l, "aliment[ií]cio|suplement|nutrac|bem[- ]?estar|sa[uú]de") ~ "Dietary Supplements",

      # Botanical / agricultural groups
      str_detect(title_l, "sement|seed|semente") ~ "Seeds",
      str_detect(title_l, "garden|jardim|ar livre|outdoor") ~ "Jardim e Ar Livre",
      str_detect(title_l, "plant|planta") ~ "Plants",
      str_detect(title_l, "especi|spice") ~ "Spices",

      TRUE ~ "To Review"
    )
  ) %>%
  select(-title_l)

# ------------------------------------------------------------
# 4) Remove non-target items such as boxes/kits and books
# ------------------------------------------------------------
df <- df %>%
  filter(!str_detect(str_to_lower(TITLE_norm), "kit c/ .*caixas|livro"))

# ------------------------------------------------------------
# 5) Remove all remaining items still labeled as "To Review"
# ------------------------------------------------------------
df_final <- df %>%
  filter(CATEGORY_final != "To Review")

# ------------------------------------------------------------
# 6) Save final cleaned and recategorized dataset
# ------------------------------------------------------------
write_csv(df_final, output_file)

# Optional summary
cat("rows:", nrow(df_final), "\n")
cat("cols:", ncol(df_final), "\n")
print(df_final %>% count(CATEGORY_final, sort = TRUE), n = Inf)
```

## Notes

The initial unified dataset contained 15,299 advertisements, and the final analytical dataset contained 15,122 advertisements after iterative recategorization and exclusion of non-relevant records. These counts are rows before deduplication: the same listing can appear in several rows. After deduplication by (species search term, listing ID), the final analytical dataset has 10,176 unique listings (see `scripts/04e_deduplicate_listings.R`). This script is a supplementary material file accompanying the article.
