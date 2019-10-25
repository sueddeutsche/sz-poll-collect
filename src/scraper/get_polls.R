# Get polls for 16 state parliaments
source("src/scraper/get_wahlrechtde_landtage.R")

df.wahlrecht %>% 
  select(Land,Institut,Datum,Befragte,Partei,Pct) ->
  df.wahlrecht

# get polls for national parliament
source("src/scraper/get_wahlrechtde_bundestag.R")

rm(t,table,i,ilinks,institute,j,jlinks,k,url)

df.wahlrecht %>% 
  unique() ->
  df_wahlrecht

rm(df.wahlrecht)

# clean data (a lot of RegEx)
source("src/clean_wahlrecht.R")

df_wahlrecht ->
  df

rm(df_wahlrecht)

