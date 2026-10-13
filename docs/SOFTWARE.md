# Software used

R 4.5.2 (R Core Team 2025). The package list below was extracted from the `library()` and `::` calls of the scripts.
The exact package versions of the original runs were not recorded; script 03 saves the `sessionInfo()` of any new run to `data/processed/sessionInfo_03_its.txt`.

| Package | Use | Scripts |
|---|---|---|
| dplyr | data manipulation | 02, 03, 04b, 04c, 04d, 04e, 05, 06, exploratory (all) |
| tidyr | reshaping data | 03, 04d, exploratory (GT and ML plots) |
| readxl | read Excel files | 03, 04b, 05, 06, exploratory (GT plots) |
| openxlsx | write Excel files | 02 |
| readr | read/write CSV | 04c, 04d, 04e, 05 |
| purrr | functional programming | 04b, 04d |
| stringr | text matching | 04c, 04d |
| tibble | tables (tribble) | 04d |
| ggplot2 | plots | 05, 06, exploratory (all) |
| forcats | factor ordering | 05, exploratory (all) |
| scales | axis labels | 05, 06, exploratory (GT and ML plots) |
| lmtest | coeftest, Durbin-Watson test | 03 |
| sandwich | Newey-West covariance (NeweyWest) | 03 |
| knitr | LaTeX tables (kable) | exploratory/gt_exploratory_plots |
| ggrepel | non-overlapping labels | exploratory/gt_exploratory_plots |
| viridis | colour scales | exploratory/ml_exploratory_plots |
| gtrendsAPI | Google Trends API (Correia 2024) | 02 (GitHub: racorreia/gtrendsAPI) |
| gkgraphR | Google Knowledge Graph API (Correia 2020) | 01 (CRAN / GitHub: racorreia/gkgraphR) |

Base R components used without installation: stats (`Box.test`), tools (`file_path_sans_ext`), utils.

Python (script 04a, Google Colab): requests 2.32.3, selenium 4.14.0, webdriver-manager 4.0.1, virtualenv, pandas, openpyxl. Python version: that of the Google Colab runtime at the time of the run (not recorded).
