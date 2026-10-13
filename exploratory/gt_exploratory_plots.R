# =============================================================================
# exploratory/gt_exploratory_plots.R
# Purpose : exploratory plots and tables from the ITS results (OLS + Newey-West).
#           Not used for the manuscript figures (see 05_manuscript_figures.R).
# Input   : data/processed/its_results_classified.csv (script 03) and data/raw/gtrends_monthly_raw.xlsx (script 02)
# Output  : outputs/exploratory/figures, outputs/exploratory/tables
# Run from the repository root.
# =============================================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(forcats)
library(ggrepel)
library(knitr)

OUT_FIG <- file.path("outputs", "exploratory", "figures")
OUT_TAB <- file.path("outputs", "exploratory", "tables")
dir.create(OUT_FIG, recursive = TRUE, showWarnings = FALSE)
dir.create(OUT_TAB, recursive = TRUE, showWarnings = FALSE)      # formatted tables

# 1. Load data
df <- read.csv(file.path("data", "processed", "its_results_classified.csv"), stringsAsFactors = FALSE)

# Remove species with insufficient data (if any)
df <- df %>% filter(!is.na(Level_Coef))

# Combined significance column for the legend
df <- df %>%
  mutate(
    sig_level = ifelse(Level_P < 0.05, "Significant", "Non-significant"),
    sig_trend = ifelse(Trend_P < 0.05, "Significant", "Non-significant"),
    combined_sig = case_when(
      Level_P < 0.05 & Trend_P < 0.05 ~ "Both",
      Level_P < 0.05 ~ "Level only",
      Trend_P < 0.05 ~ "Trend only",
      TRUE ~ "None"
    ),
    # Bubble size (smaller p = larger bubble)
    bubble_size = -log10(pmin(Level_P, Trend_P, na.rm = TRUE)) + 0.1
  )

# ============================================================================
# 2. Heatmap of coefficients (level and trend)
# ============================================================================
# Long format
df_heat <- df %>%
  select(Species, Level_Coef, Trend_Coef) %>%
  pivot_longer(cols = c(Level_Coef, Trend_Coef),
               names_to = "Effect_Type",
               values_to = "Coefficient") %>%
  mutate(Effect_Type = recode(Effect_Type,
                              "Level_Coef" = "Level (immediate)",
                              "Trend_Coef" = "Trend (slope change)"))

# Order species by level coefficient
species_order <- df %>% arrange(desc(Level_Coef)) %>% pull(Species)
df_heat$Species <- factor(df_heat$Species, levels = species_order)

p_heat <- ggplot(df_heat, aes(x = Effect_Type, y = Species, fill = Coefficient)) +
  geom_tile() +
  scale_fill_gradient2(low = "darkred", mid = "white", high = "darkgreen",
                       midpoint = 0, name = "Coefficient") +
  labs(title = "Heatmap of intervention effects",
       x = NULL, y = NULL) +
  theme_minimal(base_size = 10) +
  theme(axis.text.y = element_text(size = 6),
        legend.position = "bottom")

ggsave(file.path(OUT_FIG, "Figure_Heatmap.png"), p_heat, width = 8, height = 16, dpi = 300)

# ============================================================================
# 3. Bubble plot: level vs trend
# ============================================================================
# Colours for combined_sig
sig_colors <- c("Both" = "purple", "Level only" = "blue",
                "Trend only" = "orange", "None" = "gray70")

p_bubble <- ggplot(df, aes(x = Level_Coef, y = Trend_Coef,
                           size = bubble_size,
                           color = combined_sig,
                           label = Species)) +
  geom_point(alpha = 0.7) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  scale_color_manual(values = sig_colors, name = "Significance") +
  scale_size_continuous(range = c(2, 8), guide = "none") +
  labs(title = "Level vs Trend effects",
       x = "Level change (immediate effect)",
       y = "Trend change (slope after intervention)") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

# Add labels to extreme points (optional)
# ggrepel avoids overlapping labels
p_bubble_labeled <- p_bubble +
  geom_text_repel(data = df %>% filter(abs(Level_Coef) > 15 | abs(Trend_Coef) > 0.5),
                  aes(label = Species),
                  size = 3, box.padding = 0.3, point.padding = 0.3,
                  segment.color = "grey50", min.segment.length = 0.1)

ggsave(file.path(OUT_FIG, "Figure_Bubble.png"), p_bubble_labeled, width = 10, height = 8, dpi = 300)

# ============================================================================
# 4. Time series of selected species
# ============================================================================
# Load raw data
df_raw <- readxl::read_excel(file.path("data", "raw", "gtrends_monthly_raw.xlsx"))
df_raw$date <- as.Date(df_raw$date)
df_raw <- df_raw %>% filter(date >= as.Date("2004-01-01") & date <= as.Date("2024-01-01"))

# Select a few representative species
selected <- c("equisetum", "zingiber", "bauhinia", "solanum", "glycine", "alpinia")

# Prepare data for plotting
df_plot <- df_raw %>%
  select(date, all_of(selected)) %>%
  pivot_longer(cols = -date, names_to = "Species", values_to = "Popularity")

# Intervention date (vertical line)
intervention_date <- as.Date("2009-02-01")

p_ts <- ggplot(df_plot, aes(x = date, y = Popularity)) +
  geom_line(color = "steelblue", linewidth = 0.5) +
  geom_vline(xintercept = intervention_date, linetype = "dashed", color = "red", linewidth = 0.8) +
  facet_wrap(~ Species, scales = "free_y", ncol = 2) +
  labs(title = "Time series of selected species",
       x = "Date", y = "Popularity index") +
  theme_minimal(base_size = 10) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(file.path(OUT_FIG, "Figure_TimeSeries_Selected.png"), p_ts, width = 10, height = 12, dpi = 300)

# ============================================================================
# 5. Distribution of coefficients (histograms)
# ============================================================================
p_hist_level <- ggplot(df, aes(x = Level_Coef, fill = Level_Effect)) +
  geom_histogram(binwidth = 2, color = "black", alpha = 0.7) +
  scale_fill_manual(values = c("Positive" = "darkgreen", "Negative" = "darkred", "Non-significant" = "gray70")) +
  labs(title = "Distribution of level effects",
       x = "Level coefficient", y = "Count") +
  theme_minimal()

p_hist_trend <- ggplot(df, aes(x = Trend_Coef, fill = Trend_Effect)) +
  geom_histogram(binwidth = 0.1, color = "black", alpha = 0.7) +
  scale_fill_manual(values = c("Positive" = "blue", "Negative" = "orange", "Non-significant" = "gray70")) +
  labs(title = "Distribution of trend effects",
       x = "Trend coefficient", y = "Count") +
  theme_minimal()

ggsave(file.path(OUT_FIG, "Figure_Hist_Level.png"), p_hist_level, width = 8, height = 5, dpi = 300)
ggsave(file.path(OUT_FIG, "Figure_Hist_Trend.png"), p_hist_trend, width = 8, height = 5, dpi = 300)

# ============================================================================
# 6. Stacked bar chart (proportions)
# ============================================================================
# Proportions of effect types
prop_level <- df %>%
  count(Effect = Level_Effect) %>%
  mutate(prop = n / sum(n), Type = "Level")

prop_trend <- df %>%
  count(Effect = Trend_Effect) %>%
  mutate(prop = n / sum(n), Type = "Trend")

prop_df <- bind_rows(prop_level, prop_trend)

p_prop <- ggplot(prop_df, aes(x = Type, y = prop, fill = Effect)) +
  geom_col(position = "fill", width = 0.5) +
  scale_fill_manual(values = c("Positive" = "darkgreen", "Negative" = "darkred", "Non-significant" = "gray70")) +
  labs(title = "Proportion of species by effect type",
       x = NULL, y = "Proportion", fill = "Effect") +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent)

ggsave(file.path(OUT_FIG, "Figure_Proportions.png"), p_prop, width = 6, height = 5, dpi = 300)

# ============================================================================
# 7. Tables in LaTeX format
# ============================================================================
# Top 10 positive level effects
top10_level_pos <- df %>%
  filter(Level_Effect == "Positive") %>%
  arrange(desc(Level_Coef)) %>%
  select(Species, Level_Coef, Level_P, Trend_Coef, Trend_P) %>%
  head(10)

# Top 10 negative level effects
top10_level_neg <- df %>%
  filter(Level_Effect == "Negative") %>%
  arrange(Level_Coef) %>%
  select(Species, Level_Coef, Level_P, Trend_Coef, Trend_P) %>%
  head(10)

# Top 10 positive trend effects
top10_trend_pos <- df %>%
  filter(Trend_Effect == "Positive") %>%
  arrange(desc(Trend_Coef)) %>%
  select(Species, Trend_Coef, Trend_P, Level_Coef, Level_P) %>%
  head(10)

# Top 10 negative trend effects
top10_trend_neg <- df %>%
  filter(Trend_Effect == "Negative") %>%
  arrange(Trend_Coef) %>%
  select(Species, Trend_Coef, Trend_P, Level_Coef, Level_P) %>%
  head(10)

# Save as CSV
write.csv(top10_level_pos, file.path(OUT_TAB, "Table_Top10_Level_Positive.csv"), row.names = FALSE)
write.csv(top10_level_neg, file.path(OUT_TAB, "Table_Top10_Level_Negative.csv"), row.names = FALSE)
write.csv(top10_trend_pos, file.path(OUT_TAB, "Table_Top10_Trend_Positive.csv"), row.names = FALSE)
write.csv(top10_trend_neg, file.path(OUT_TAB, "Table_Top10_Trend_Negative.csv"), row.names = FALSE)

# LaTeX version (copy-paste)
sink(file.path(OUT_TAB, "tables_latex.txt"))
cat("\\begin{table}[h]\n\\caption{Top 10 positive level effects}\n")
print(kable(top10_level_pos, format = "latex", digits = 3))
cat("\\end{table}\n\n")

cat("\\begin{table}[h]\n\\caption{Top 10 negative level effects}\n")
print(kable(top10_level_neg, format = "latex", digits = 3))
cat("\\end{table}\n\n")

cat("\\begin{table}[h]\n\\caption{Top 10 positive trend effects}\n")
print(kable(top10_trend_pos, format = "latex", digits = 3))
cat("\\end{table}\n\n")

cat("\\begin{table}[h]\n\\caption{Top 10 negative trend effects}\n")
print(kable(top10_trend_neg, format = "latex", digits = 3))
cat("\\end{table}\n")
sink()

# ============================================================================
# 8. Additional descriptive statistics
# ============================================================================
# Correlation between level and trend effects
cor_test <- cor.test(df$Level_Coef, df$Trend_Coef, method = "pearson")
cat("\n=== Correlation between level and trend effects ===\n")
print(cor_test)

# Save summary statistics
summary_stats <- df %>%
  summarise(
    mean_level = mean(Level_Coef, na.rm = TRUE),
    sd_level = sd(Level_Coef, na.rm = TRUE),
    mean_trend = mean(Trend_Coef, na.rm = TRUE),
    sd_trend = sd(Trend_Coef, na.rm = TRUE),
    n_significant_level = sum(Level_P < 0.05, na.rm = TRUE),
    n_significant_trend = sum(Trend_P < 0.05, na.rm = TRUE)
  )

write.csv(summary_stats, file.path(OUT_TAB, "summary_statistics.csv"), row.names = FALSE)

cat("\n=== Analyses completed ===\n")
cat("Files generated: heatmap, bubble plot, time series, histograms, tables.\n")