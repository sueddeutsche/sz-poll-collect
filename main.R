# Load required packages
source("src/config.R")

# Scrape Poll data from Wahlrecht.de
source("src/scraper/get_polls.R")

# Load elections data from disk
source("src/scraper/get_elections.R")

# Match polls to corresponding elections
source("src/join_votedates.R")

# Clean dataset
source("src/clean_df.R")

# Some tables and plots for analysis
source("src/analyze_quality.R")
source("src/analyze_parties.R")
source("src/analyze_uncertainty.R")