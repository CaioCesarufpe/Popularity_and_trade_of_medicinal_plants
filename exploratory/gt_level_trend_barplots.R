# =============================================================================
# exploratory/gt_level_trend_barplots.R
# Purpose : bar plots and tables of species with significant LEVEL and TREND effects
#           (exploratory; the manuscript reports the trend effect only, see 05_manuscript_figures.R).
# Input   : data/processed/its_results_classified.csv (script 03)
# Output  : outputs/exploratory/figures/*.png and outputs/exploratory/tables/*.csv
# Run from the repository root.
# =============================================================================
OUT_FIG <- file.path("outputs", "exploratory", "figures")
OUT_TAB <- file.path("outputs", "exploratory", "tables")
dir.create(OUT_FIG, recursive = TRUE, showWarnings = FALSE)
dir.create(OUT_TAB, recursive = TRUE, showWarnings = FALSE)

library(ggplot2)
library(dplyr)
library(forcats)

# Read classified results
df <- read.csv(file.path("data", "processed", "its_results_classified.csv"), stringsAsFactors = FALSE)

# 1. Level effect plot (positive and negative separately)
level_positive <- df %>% filter(Level_Effect == "Positive") %>%
  arrange(desc(Level_Coef))
level_negative <- df %>% filter(Level_Effect == "Negative") %>%
  arrange(Level_Coef)  # most negative first

# Positive level plot
if (nrow(level_positive) > 0) {
  level_positive <- level_positive %>%
    mutate(Species = fct_reorder(Species, Level_Coef, .desc = FALSE))
  
  p_pos <- ggplot(level_positive, aes(x = Level_Coef, y = Species)) +
    geom_col(fill = "darkgreen", width = 0.7) +
    labs(
      title = "Species with significant positive level effect (p < 0.05)",
      x = "Level change (immediate effect)",
      y = NULL
    ) +
    theme_minimal(base_size = 12) +
    theme(panel.grid.major.y = element_blank())
  
  ggsave(file.path(OUT_FIG, "Figure_Level_Positive.png"), p_pos, width = 8, height = 4, dpi = 300)
  write.csv(level_positive %>% select(Species, Level_Coef, Level_P),
            file.path(OUT_TAB, "Table_Level_Positive.csv"), row.names = FALSE)
}

# Negative level plot
if (nrow(level_negative) > 0) {
  level_negative <- level_negative %>%
    mutate(Species = fct_reorder(Species, Level_Coef, .desc = TRUE))
  
  p_neg <- ggplot(level_negative, aes(x = Level_Coef, y = Species)) +
    geom_col(fill = "darkred", width = 0.7) +
    labs(
      title = "Species with significant negative level effect (p < 0.05)",
      x = "Level change (immediate effect)",
      y = NULL
    ) +
    theme_minimal(base_size = 12) +
    theme(panel.grid.major.y = element_blank())
  
  ggsave(file.path(OUT_FIG, "Figure_Level_Negative.png"), p_neg, width = 8, height = 10, dpi = 300)
  write.csv(level_negative %>% select(Species, Level_Coef, Level_P),
            file.path(OUT_TAB, "Table_Level_Negative.csv"), row.names = FALSE)
}

# 2. Trend effect plots (similar)
trend_positive <- df %>% filter(Trend_Effect == "Positive") %>%
  arrange(desc(Trend_Coef))
trend_negative <- df %>% filter(Trend_Effect == "Negative") %>%
  arrange(Trend_Coef)

# Positive trend
if (nrow(trend_positive) > 0) {
  trend_positive <- trend_positive %>%
    mutate(Species = fct_reorder(Species, Trend_Coef, .desc = FALSE))
  
  p_tpos <- ggplot(trend_positive, aes(x = Trend_Coef, y = Species)) +
    geom_col(fill = "blue", width = 0.7) +
    labs(
      title = "Species with significant positive trend change (p < 0.05)",
      x = "Trend change (slope after intervention)",
      y = NULL
    ) +
    theme_minimal(base_size = 12) +
    theme(panel.grid.major.y = element_blank())
  
  ggsave(file.path(OUT_FIG, "Figure_Trend_Positive.png"), p_tpos, width = 8, height = 8, dpi = 300)
  write.csv(trend_positive %>% select(Species, Trend_Coef, Trend_P),
            file.path(OUT_TAB, "Table_Trend_Positive.csv"), row.names = FALSE)
}

# Negative trend
if (nrow(trend_negative) > 0) {
  trend_negative <- trend_negative %>%
    mutate(Species = fct_reorder(Species, Trend_Coef, .desc = TRUE))
  
  p_tneg <- ggplot(trend_negative, aes(x = Trend_Coef, y = Species)) +
    geom_col(fill = "orange", width = 0.7) +
    labs(
      title = "Species with significant negative trend change (p < 0.05)",
      x = "Trend change (slope after intervention)",
      y = NULL
    ) +
    theme_minimal(base_size = 12) +
    theme(panel.grid.major.y = element_blank())
  
  ggsave(file.path(OUT_FIG, "Figure_Trend_Negative.png"), p_tneg, width = 8, height = 4, dpi = 300)
  write.csv(trend_negative %>% select(Species, Trend_Coef, Trend_P),
            file.path(OUT_TAB, "Table_Trend_Negative.csv"), row.names = FALSE)
}

# 3. Summary tables (optional)
write.csv(df, file.path(OUT_TAB, "final_classified_results.csv"), row.names = FALSE)