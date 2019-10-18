source("src/get_wahlrechtde_landtage.R")

df.wahlrecht %>% 
  select(Land,Institut,Datum,Befragte,Partei,Pct) ->
  df.wahlrecht

source("src/get_wahlrechtde_bundestag.R")

df.wahlrecht %>% 
  mutate(
    Institut = str_remove(Institut,".htm"),
    Datum = dmy(Datum)
    ) %>% 
  filter(
    !is.na(Datum),
    !str_detect(Befragte, "wahl")
    )