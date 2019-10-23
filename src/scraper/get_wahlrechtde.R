source("src/scraper/get_wahlrechtde_landtage.R")

df.wahlrecht %>% 
  select(Land,Institut,Datum,Befragte,Partei,Pct) ->
  df.wahlrecht

source("src/scraper/get_wahlrechtde_bundestag.R")

rm(t,table,i,ilinks,institute,j,jlinks,k,url)

df.wahlrecht %>% 
  unique() ->
  df_wahlrecht

rm(df.wahlrecht)