source("src/scraper/get_dawum.R")

source("src/scraper/get_wahlrechtde.R")

source("src/clean_wahlrecht.R")

df ->
  df_dawum

save(df_dawum,file = "data/df_dawum.Rdata")

df_wahlrecht ->
  df

rm(df_dawum,df_wahlrecht)

