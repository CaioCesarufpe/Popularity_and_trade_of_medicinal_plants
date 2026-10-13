# =============================================================================
# exploratory/ml_exploratory_plots.R
# Purpose : exploratory descriptive plots of the unified Mercado Livre listings
#           (not used for the manuscript figures, see 05_manuscript_figures.R).
#           NOTE: no deduplication by (source, ID) is applied here, unlike the manuscript analyses.
# Input   : data/processed/ml_unified_listings.csv (script 04b)
# Output  : outputs/exploratory/figures and outputs/exploratory/tables
# Run from the repository root.
# =============================================================================

# Load packages
library(ggplot2)
library(dplyr)
library(tidyr)
library(forcats)
library(viridis)

OUT_FIG <- file.path("outputs", "exploratory", "figures")
OUT_TAB <- file.path("outputs", "exploratory", "tables")
dir.create(OUT_FIG, recursive = TRUE, showWarnings = FALSE)
dir.create(OUT_TAB, recursive = TRUE, showWarnings = FALSE)

# Read the CSV file
dados <- read.csv(file.path("data", "processed", "ml_unified_listings.csv"), stringsAsFactors = FALSE)

# Initial cleaning
# Standardise categories (the grepl patterns match the original Portuguese category names of Mercado Livre)
dados$CATEGORY <- trimws(dados$CATEGORY)
dados <- dados %>%
  mutate(CATEGORY = case_when(
    grepl("Saude", CATEGORY, ignore.case = TRUE) ~ "Health",
    grepl("Suplementos Alimentares", CATEGORY) ~ "Dietary Supplements",
    grepl("Cha", CATEGORY) ~ "Tea",
    grepl("Plantas", CATEGORY) ~ "Plants",
    grepl("Jardim", CATEGORY) ~ "Garden",
    grepl("Sementes", CATEGORY) ~ "Seeds",
    grepl("Sem Categoria", CATEGORY) ~ "Uncategorized",
    TRUE ~ CATEGORY
  ))

# Make sure source is a factor
dados$source <- as.factor(dados$source)

# If Is_Medicinal exists, convert it to logical (TRUE/FALSE)
if("Is_Medicinal" %in% colnames(dados)) {
  dados$Is_Medicinal <- as.logical(dados$Is_Medicinal)
}

# ----------------------------------------------------------------------
# Plot 1: Top 20 sources by number of products
top_sources <- dados %>%
  group_by(source) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  slice_head(n = 20)

# Save table
write.csv(top_sources, file.path(OUT_TAB, "table1_top_sources.csv"), row.names = FALSE)

p1 <- ggplot(top_sources, aes(x = count, y = fct_reorder(source, count))) +
  geom_col(fill = "#2c7fb8") +
  labs(
    title = "Number of Products per Plant Source",
    x = "Number of products",
    y = "Plant source",
    caption = "Top 20 plant sources by product count."
  ) +
  theme_minimal(base_size = 10) +
  theme(plot.caption = element_text(hjust = 0, face = "italic"))

ggsave(file.path(OUT_FIG, "fig1_top_sources.png"), p1, width = 12, height = 10, units = "cm", dpi = 300)

# ----------------------------------------------------------------------
# Plot 2: Number of products per category
cat_counts <- dados %>%
  group_by(CATEGORY) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

write.csv(cat_counts, file.path(OUT_TAB, "table2_category_counts.csv"), row.names = FALSE)

p2 <- ggplot(cat_counts, aes(x = count, y = fct_reorder(CATEGORY, count))) +
  geom_col(fill = "#238b45") +
  labs(
    title = "Number of Products per Category",
    x = "Number of products",
    y = "Category",
    caption = "Total products in each category."
  ) +
  theme_minimal(base_size = 10) +
  theme(plot.caption = element_text(hjust = 0, face = "italic"))

ggsave(file.path(OUT_FIG, "fig2_category_counts.png"), p2, width = 12, height = 8, units = "cm", dpi = 300)

# ----------------------------------------------------------------------
# Plot 3: Heatmap of counts, source x category (top 15 sources and main categories)
top15_sources <- dados %>%
  group_by(source) %>%
  summarise(n = n()) %>%
  top_n(15, n) %>%
  pull(source)

main_cats <- dados %>%
  group_by(CATEGORY) %>%
  summarise(n = n()) %>%
  filter(n >= 10) %>%
  pull(CATEGORY)

heat_data <- dados %>%
  filter(source %in% top15_sources, CATEGORY %in% main_cats) %>%
  group_by(source, CATEGORY) %>%
  summarise(count = n(), .groups = "drop") %>%
  complete(source, CATEGORY, fill = list(count = 0))

write.csv(heat_data, file.path(OUT_TAB, "table3_heatmap_source_category.csv"), row.names = FALSE)

p3 <- ggplot(heat_data, aes(x = CATEGORY, y = source, fill = count)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "#08519c", name = "Count") +
  labs(
    title = "Heatmap of Product Counts: Source vs Category",
    x = "Category",
    y = "Plant source",
    caption = "Counts for top 15 sources and main categories (≥10 products)."
  ) +
  theme_minimal(base_size = 10) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.caption = element_text(hjust = 0, face = "italic"))

ggsave(file.path(OUT_FIG, "fig3_heatmap_source_category.png"), p3, width = 14, height = 12, units = "cm", dpi = 300)

# ----------------------------------------------------------------------
# Plot 4: Top 10 sources with the highest proportion of medicinal products (if the column exists)
if("Is_Medicinal" %in% colnames(dados) && any(!is.na(dados$Is_Medicinal))) {
  # Proportion of medicinal products per source (sources with at least 5 products)
  medicinal_prop <- dados %>%
    group_by(source) %>%
    summarise(
      total = n(),
      medicinal = sum(Is_Medicinal, na.rm = TRUE),
      prop = medicinal / total
    ) %>%
    filter(total >= 5) %>%
    arrange(desc(prop)) %>%
    slice_head(n = 10)
  
  write.csv(medicinal_prop, file.path(OUT_TAB, "table4_top_medicinal_sources.csv"), row.names = FALSE)
  
  p4 <- ggplot(medicinal_prop, aes(x = prop, y = fct_reorder(source, prop))) +
    geom_col(fill = "#d95f0e") +
    scale_x_continuous(labels = scales::percent) +
    labs(
      title = "Proportion of Medicinal Products per Source",
      x = "Proportion of medicinal products",
      y = "Plant source",
      caption = "Top 10 sources with highest proportion of medicinal products (≥5 products total)."
    ) +
    theme_minimal(base_size = 10) +
    theme(plot.caption = element_text(hjust = 0, face = "italic"))
  
  ggsave(file.path(OUT_FIG, "fig4_medicinal_proportion.png"), p4, width = 12, height = 10, units = "cm", dpi = 300)
} else {
  # If there are no medicinal data, plot the category distribution for the top 10 sources instead
  top10_sources <- dados %>%
    group_by(source) %>%
    summarise(total = n()) %>%
    top_n(10, total) %>%
    pull(source)
  
  stack_data <- dados %>%
    filter(source %in% top10_sources) %>%
    group_by(source, CATEGORY) %>%
    summarise(count = n(), .groups = "drop") %>%
    group_by(source) %>%
    mutate(prop = count / sum(count))
  
  write.csv(stack_data, file.path(OUT_TAB, "table4_category_distribution_top10.csv"), row.names = FALSE)
  
  p4 <- ggplot(stack_data, aes(x = source, y = prop, fill = CATEGORY)) +
    geom_col(position = "fill") +
    scale_y_continuous(labels = scales::percent) +
    scale_fill_viridis_d() +
    labs(
      title = "Category Distribution for Top 10 Plant Sources",
      x = "Plant source",
      y = "Proportion",
      fill = "Category",
      caption = "Relative frequency of categories within each source."
    ) +
    theme_minimal(base_size = 10) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.caption = element_text(hjust = 0, face = "italic"))
  
  ggsave(file.path(OUT_FIG, "fig4_category_distribution.png"), p4, width = 14, height = 10, units = "cm", dpi = 300)
}

# ----------------------------------------------------------------------
# Plot 5: Number of products by source and category (stacked bars, top 10 sources)
# (stack_data was computed above; here absolute values are used)
top10_sources <- dados %>%
  group_by(source) %>%
  summarise(total = n()) %>%
  top_n(10, total) %>%
  pull(source)

stack_abs <- dados %>%
  filter(source %in% top10_sources) %>%
  group_by(source, CATEGORY) %>%
  summarise(count = n(), .groups = "drop")

write.csv(stack_abs, file.path(OUT_TAB, "table5_absolute_category_by_source.csv"), row.names = FALSE)

p5 <- ggplot(stack_abs, aes(x = source, y = count, fill = CATEGORY)) +
  geom_col(position = "stack") +
  scale_fill_viridis_d() +
  labs(
    title = "Product Counts by Category for Top 10 Plant Sources",
    x = "Plant source",
    y = "Number of products",
    fill = "Category",
    caption = "Absolute counts of products per category for the 10 most frequent sources."
  ) +
  theme_minimal(base_size = 10) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.caption = element_text(hjust = 0, face = "italic"))

ggsave(file.path(OUT_FIG, "fig5_absolute_category_by_source.png"), p5, width = 14, height = 10, units = "cm", dpi = 300)

cat("Plots and tables generated successfully!\n")