# =============================================================================
# 03_gt_its_ols_newey_west.R
# Purpose : Interrupted time series (ITS) analysis of Google Trends popularity
#           for each RENISUS species, using segmented OLS regression with
#           Newey-West (HAC) standard errors.
# Model   : popularity ~ time + intervention + time_after
#             time         = months since the first observation
#             intervention = 0 before February 2009, 1 from February 2009 (RENISUS publication)
#             time_after   = months since the intervention (0 before it)
#           The coefficient of `time_after` is the CHANGE IN TREND after the
#           intervention (the quantity reported in the manuscript); the
#           coefficient of `intervention` is the immediate level change
#           (estimated as an adjustment term, not interpreted in the manuscript).
# Input   : data/raw/gtrends_monthly_raw.xlsx (script 02): 240 monthly points, 2004-01 to 2023-12
# Output  : data/processed/its_results_neweywest_full.csv
#           data/processed/its_results_classified.csv
# =============================================================================

library(readxl)
library(dplyr)
library(tidyr)
library(lmtest)    # coeftest, dwtest
library(sandwich)  # NeweyWest

# --- Settings -----------------------------------------------------------------
INPUT_FILE        <- file.path("data", "raw", "gtrends_monthly_raw.xlsx")
OUT_DIR           <- file.path("data", "processed")
START_DATE        <- as.Date("2004-01-01")
END_DATE          <- as.Date("2023-12-01")  # last month of the series (240 monthly points)
INTERVENTION_DATE <- as.Date("2009-02-01")  # publication of the RENISUS list
NW_LAG            <- 4                      # Newey-West lag
dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

# --- 1. Load data ---------------------------------------------------------------
df <- read_excel(INPUT_FILE)
df$date <- as.Date(df$date)
df <- df %>% filter(date >= START_DATE & date <= END_DATE)

# --- Create variables -------------------------------------------------------------
df$time <- as.numeric(df$date - min(df$date)) / 30.44   # approximate months
df$intervention <- ifelse(df$date >= INTERVENTION_DATE, 1, 0)

# First post-intervention time point
first_post <- min(df$date[df$intervention == 1])
df$time_after <- ifelse(df$intervention == 1,
                        as.numeric(df$date - first_post) / 30.44,
                        0)

# Species columns
species_names <- setdiff(names(df), c("date", "time", "intervention", "time_after"))

results_list <- list()

# --- 2. Fit one model per species ---------------------------------------------------
for (sp in species_names) {
  # Subset without NAs
  sub_df <- df %>% select(time, intervention, time_after, species = all_of(sp)) %>% drop_na()

  # Skip series without variation (model cannot be fitted)
  if (var(sub_df$species, na.rm = TRUE) == 0) {
    cat("Species", sp, "has no variation - skipped\n")
    next
  }

  # OLS fit
  model <- lm(species ~ time + intervention + time_after, data = sub_df)

  # Skip if any coefficient is NA (collinearity)
  coefs <- coef(model)
  if (any(is.na(coefs))) {
    cat("Species", sp, "has NA coefficients - skipped\n")
    next
  }

  # Newey-West standard errors (fixed lag, no prewhitening)
  nw_vcov <- NeweyWest(model, lag = NW_LAG, prewhite = FALSE)
  nw_test <- coeftest(model, vcov = nw_vcov)

  p_intervention <- nw_test["intervention", "Pr(>|t|)"]
  p_time_after   <- nw_test["time_after", "Pr(>|t|)"]

  # Residual autocorrelation diagnostics
  resid <- residuals(model)
  dw <- dwtest(model)                                   # Durbin-Watson
  lb <- Box.test(resid, lag = 12, type = "Ljung-Box")   # Ljung-Box (lag 12 = annual seasonality)

  results_list[[sp]] <- data.frame(
    Species    = sp,
    Level_Coef = coefs["intervention"],
    Level_P    = p_intervention,
    Trend_Coef = coefs["time_after"],
    Trend_P    = p_time_after,
    DW_stat    = dw$statistic,
    DW_p       = dw$p.value,
    LB_stat    = lb$statistic,
    LB_p       = lb$p.value,
    stringsAsFactors = FALSE
  )
}

results_df <- bind_rows(results_list)

# --- 3. Save full results -------------------------------------------------------------
write.csv(results_df, file.path(OUT_DIR, "its_results_neweywest_full.csv"), row.names = FALSE)

# --- Summary (p < 0.05) -----------------------------------------------------------------
cat("\nSummary of results (p < 0.05):\n")
cat("Species analysed:", nrow(results_df), "\n")
cat("Significant level effect:", sum(results_df$Level_P < 0.05, na.rm = TRUE), "\n")
cat("Significant trend effect:", sum(results_df$Trend_P < 0.05, na.rm = TRUE), "\n")

# --- 4. Classify species by effect type ---------------------------------------------------
results_df <- results_df %>%
  mutate(
    Level_Effect = ifelse(Level_P < 0.05,
                          ifelse(Level_Coef > 0, "Positive", "Negative"),
                          "Non-significant"),
    Trend_Effect = ifelse(Trend_P < 0.05,
                          ifelse(Trend_Coef > 0, "Positive", "Negative"),
                          "Non-significant")
  )

print(table(results_df$Level_Effect))
print(table(results_df$Trend_Effect))

write.csv(results_df, file.path(OUT_DIR, "its_results_classified.csv"), row.names = FALSE)

# Record package versions for reproducibility
writeLines(capture.output(sessionInfo()), file.path(OUT_DIR, "sessionInfo_03_its.txt"))
