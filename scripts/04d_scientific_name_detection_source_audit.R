# Reproducible workflow for scientific-name detection, source auditing,
# manual source-status curation, and final export.

# =============================================================================
# 04d_scientific_name_detection_source_audit.R
# Purpose : detect scientific names (species/genus level) in listing titles, audit the
#           search-term sources (`source`) and export the final recategorized dataset.
#           The `source` values are the Brazilian-Portuguese common names used as search terms (data).
# Input   : data/processed/ml_recategorized_en_final.csv (script 04c)
# Output  : data/processed/ml_recategorized_scientific_final.csv and audit tables in outputs/tables
# Run from the repository root.
# =============================================================================

library(readr)
library(dplyr)
library(stringr)
library(tidyr)
dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)
library(purrr)

# -----------------------------------------------------------------------------
# 1) Load the recategorized base
# -----------------------------------------------------------------------------
base <- read_csv(
  file.path("data", "processed", "ml_recategorized_en_final.csv"),
  show_col_types = FALSE
)

# -----------------------------------------------------------------------------
# 2) Define the cleaned taxonomic dictionary (RENISUS names, including synonyms and outdated names)
#    (A popular-names table was loaded in the original script but never used; it was removed.)
# -----------------------------------------------------------------------------

genera <- c(
  "Aloe", "Alpinia", "Bauhinia", "Copaifera", "Cordia", "Costus",
  "Croton", "Maytenus", "Mentha", "Mikania", "Morus", "Passiflora",
  "Persea", "Phyllanthus", "Polygonum", "Syzygium", "Vernonia"
)

species_names <- c(
  "Achillea millefolium", "Allium sativum", "Anacardium occidentale",
  "Ananas comosus", "Apuleia ferrea", "Caesalpinia ferrea",
  "Arrabidaea chica", "Artemisia absinthium", "Baccharis trimera",
  "Bidens pilosa", "Calendula officinalis", "Carapa guianensis",
  "Casearia sylvestris", "Chamomilla recutita", "Matricaria chamomilla",
  "Matricaria recutita", "Chenopodium ambrosioides", "Curcuma longa",
  "Cynara scolymus", "Dalbergia subcymosa", "Eleutherine plicata",
  "Equisetum arvense", "Erythrina mulungu", "Eucalyptus globulus",
  "Eugenia uniflora", "Myrtus brasiliana", "Foeniculum vulgare",
  "Glycine max", "Harpagophytum procumbens", "Jatropha gossypiifolia",
  "Justicia pectoralis", "Kalanchoe pinnata", "Bryophyllum calycinum",
  "Lamium album", "Lippia sidoides", "Malva sylvestris",
  "Mentha pulegium", "Momordica charantia", "Ocimum gratissimum",
  "Orbignya speciosa", "Petroselinum sativum", "Plantago major",
  "Plectranthus barbatus", "Coleus barbatus", "Portulaca pilosa",
  "Psidium guajava", "Punica granatum", "Rhamnus purshiana",
  "Ruta graveolens", "Salix alba", "Schinus terebinthifolius",
  "Schinus aroeira", "Solanum paniculatum", "Solidago microglossa",
  "Stryphnodendron adstringens", "Stryphnodendron barbatimam",
  "Tabebuia avellanedae", "Tagetes minuta", "Trifolium pratense",
  "Uncaria tomentosa", "Vernonia condensata", "Zingiber officinale"
)

# -----------------------------------------------------------------------------
# 3) Scientific-name detection
#    - Species have priority over genera.
#    - TAXON_MATCH stores the first matched taxon.
# -----------------------------------------------------------------------------
match_taxon <- function(title_text) {
  t <- str_to_lower(title_text)
  
  species_hit <- species_names[str_detect(t, fixed(str_to_lower(species_names)))]
  genera_hit <- genera[str_detect(t, str_c("\\b", str_to_lower(genera), "\\b"))]
  
  if (length(species_hit) > 0) return(species_hit[1])
  if (str_detect(t, "\\bvernonia condensata\\b")) return("Vernonia condensata")
  if (length(genera_hit) > 0) return(genera_hit[1])
  
  NA_character_
}

base <- base %>%
  mutate(
    TAXON_MATCH = map_chr(TITLE_norm, match_taxon),
    BY_SCIENTIFIC_NAME = !is.na(TAXON_MATCH),
    SCIENTIFIC_MATCH_TYPE = case_when(
      TAXON_MATCH %in% species_names ~ "species",
      TAXON_MATCH %in% genera ~ "genus",
      TRUE ~ NA_character_
    )
  ) %>%
  select(-BY_POPULAR_NAME, -Is_Medicinal)

# -----------------------------------------------------------------------------
# 4) Audit outputs for traceability
# -----------------------------------------------------------------------------
write_csv(
  base,
  file.path("data", "processed", "ml_recategorized_scientific_v2.csv")
)

write_csv(
  base %>% filter(BY_SCIENTIFIC_NAME),
  file.path("outputs", "tables", "ml_scientific_matches_audit.csv")
)

# -----------------------------------------------------------------------------
# 5) Build source-status map from manual review
#    - taxon_source: source is biologically informative
#    - ambiguous_context: source is context-dependent or noisy
# -----------------------------------------------------------------------------
source_status_map <- tibble::tribble(
  ~source,               ~source_status,
  "sete-dores",         "taxon_source",
  "alfavacão",          "taxon_source",
  "chambá",             "taxon_source",
  "cavalinha",          "taxon_source",
  "tanchagem",          "taxon_source",
  "erva-doce",          "taxon_source",
  "calêndula",          "taxon_source",
  "picão preto",        "taxon_source",
  "guaçatonga",         "taxon_source",
  "jambolão",           "taxon_source",
  "arruda",             "taxon_source",
  "guaco",              "taxon_source",
  "camomila",           "taxon_source",
  "eucalipto azul",     "taxon_source",
  "poejo",              "taxon_source",
  "pata-de-vaca",       "taxon_source",
  "baleeira",           "taxon_source",
  "malva-das-boticas",  "taxon_source",
  "erva-pombinha",      "taxon_source",
  "carqueja amarga",    "taxon_source",
  "goiaba",             "taxon_source",
  "pitangueira",        "taxon_source",
  "ipê-roxo",           "taxon_source",
  "boldo-africano",     "taxon_source",
  "amora",              "taxon_source",
  "assa-peixe",         "taxon_source",
  "marassacaca",        "taxon_source",
  "copaífera",          "taxon_source",
  "melão-são-caetano",  "taxon_source",
  "acajaiba",           "taxon_source",
  "absinto",            "taxon_source",
  "abacate",            "ambiguous_context",
  "gengibre",           "ambiguous_context",
  "maracuj",            "ambiguous_context",
  "maracujá",           "ambiguous_context",
  "menta",              "ambiguous_context",
  "babosa",             "ambiguous_context",
  "abacaxi",            "ambiguous_context",
  "soja",               "ambiguous_context",
  "alho",               "ambiguous_context",
  "colônia",            "ambiguous_context",
  "salsa",              "ambiguous_context",
  "aroeira",            "ambiguous_context",
  "alecrim-pimenta",    "taxon_source",
  "marupá",             "ambiguous_context",
  "cajuru",             "ambiguous_context",
  "chinchilho",         "ambiguous_context",
  "verônica",           "ambiguous_context"
)

base_final <- base %>%
  left_join(source_status_map, by = "source") %>%
  mutate(source_status = coalesce(source_status, "review_needed"))

# -----------------------------------------------------------------------------
# 6) Final validations and final export
# -----------------------------------------------------------------------------
write_csv(
  base_final,
  file.path("data", "processed", "ml_recategorized_scientific_final.csv")
)

final_summary <- base_final %>%
  count(source_status, CATEGORY_final, sort = TRUE)

write_csv(
  final_summary,
  file.path("outputs", "tables", "final_source_status_summary.csv")
)

# -----------------------------------------------------------------------------
# 7) Reproducibility checks
# -----------------------------------------------------------------------------
base_final %>%
  summarise(
    n = n(),
    n_source = n_distinct(source),
    n_id = n_distinct(ID),
    n_taxon_source = sum(source_status == "taxon_source"),
    n_ambiguous = sum(source_status == "ambiguous_context"),
    n_review = sum(source_status == "review_needed")
  )

base_final %>% count(source_status, sort = TRUE)
base_final %>% count(source_status, CATEGORY_final)
base_final %>% filter(source_status == "review_needed") %>% count(source, sort = TRUE)