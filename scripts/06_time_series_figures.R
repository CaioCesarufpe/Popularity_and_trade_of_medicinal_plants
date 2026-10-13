# =============================================================================
# 06_time_series_figures.R
# Purpose : Google Trends time-series figures of the manuscript:
#             Fig. 1  - cashew (Anacardium occidentale)
#             Fig. 5A - Glycine max;  Fig. 5B - Equisetum arvense;  Fig. 5C - Bauhinia spp.
#           Figs. 5A-C use the same code as Fig. 1, applied to other species, with a dashed
#           vertical line at the RENISUS publication (February 2009).
# Input   : data/raw/gtrends_monthly_raw.xlsx (script 02; columns "date" + one column per species)
# Output  : outputs/figures/Fig01_cashew_timeseries.png, Fig05A_glycine_timeseries.png,
#           Fig05B_equisetum_timeseries.png, Fig05C_bauhinia_timeseries.png
# Note    : this script was RECONSTRUCTED from the original Figure 1 script after the original
#           Figure 5 script was lost. The style is the same, but the output may differ slightly
#           from the figures originally included in the manuscript.
# Run from the repository root.
# =============================================================================

library(readxl)
library(dplyr)
library(ggplot2)
library(scales)

OUT_FIG <- file.path("outputs", "figures")
dir.create(OUT_FIG, recursive = TRUE, showWarnings = FALSE)

gt_raw <- read_excel(file.path("data", "raw", "gtrends_monthly_raw.xlsx")) %>%
  mutate(date = as.Date(date))

# Period shown in the subtitle, taken from the data themselves
period_label <- paste(format(min(gt_raw$date), "%Y"), format(max(gt_raw$date), "%Y"), sep = "-")

RENISUS_DATE <- as.Date("2009-02-01")  # publication of the RENISUS list

plot_series <- function(column, title, add_intervention = FALSE) {
  p <- ggplot(gt_raw, aes(x = date, y = .data[[column]])) +
    geom_line(color = "#2E8B57", linewidth = 0.95, lineend = "round")

  if (add_intervention) {
    p <- p + geom_vline(xintercept = RENISUS_DATE, linetype = "dashed",
                        color = "red", linewidth = 0.8)
  }

  subtitle <- paste0("Google Trends popularity in Brazil, ", period_label,
                     if (add_intervention) "; dashed line: RENISUS publication (Feb 2009)" else "")

  p +
    scale_x_date(date_breaks = "2 years", date_labels = "%Y",
                 expand = expansion(mult = c(0.02, 0.03))) +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20),
                       expand = expansion(mult = c(0, 0.03))) +
    labs(title = title, subtitle = subtitle, x = "Year",
         y = "Search popularity index (0-100)") +
    theme_minimal(base_size = 16) +
    theme(
      plot.title = element_text(face = "bold.italic", size = 18, hjust = 0.5),
      plot.subtitle = element_text(size = 12.5, hjust = 0.5, color = "grey30"),
      axis.title = element_text(size = 14, color = "black"),
      axis.text = element_text(size = 12.5, color = "black"),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_line(color = "grey85", linewidth = 0.35),
      panel.grid.major.y = element_line(color = "grey88", linewidth = 0.35),
      plot.margin = margin(t = 20, r = 25, b = 15, l = 15)
    )
}

save_fig <- function(p, file) {
  ggsave(file.path(OUT_FIG, file), plot = p, width = 10.5, height = 6, dpi = 300, bg = "white")
}

fig1  <- plot_series("anacardium", "Cashew (Anacardium occidentale)")
fig5a <- plot_series("glycine",   "Glycine max",       add_intervention = TRUE)
fig5b <- plot_series("equisetum", "Equisetum arvense", add_intervention = TRUE)
fig5c <- plot_series("bauhinia",  "Bauhinia spp.",     add_intervention = TRUE)

save_fig(fig1,  "Fig01_cashew_timeseries.png")
save_fig(fig5a, "Fig05A_glycine_timeseries.png")
save_fig(fig5b, "Fig05B_equisetum_timeseries.png")
save_fig(fig5c, "Fig05C_bauhinia_timeseries.png")
