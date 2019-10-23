# Befragte cleanen

save(df_wahlrecht, file = "data/df_wahlrecht_raw.Rdata")

df_wahlrecht %>%
  mutate(
    Institut = str_remove(Institut,".htm"),
    Datum = dmy(Datum),
    Pct = str_remove(Pct," %"),
    Pct = str_replace(Pct,",","."),
    Partei = ifelse(Partei %in% c("CDU","CSU","CDU/CSU"),"CDUCSU",Partei),
    Pct = str_remove(Pct,"[*]"),
    Pct = str_remove(Pct,"[*][*]"),
    Pct = str_remove(Pct,"[*][*][*]"),
    Pct = str_remove(Pct,"%"),
    Pct = str_remove(Pct,"[*]"),
    Pct = str_remove(Pct," "),
  ) %>%
  filter(
    !is.na(Datum),
    !str_detect(Befragte, "wahl"),
    Partei %in% c("CDUCSU","SPD","GRÜNE","FDP","LINKE","AfD","PDS"),
    !str_detect(Pct,"[?]"),
    !str_detect(Pct,"[a-z]"),
    Pct != "–"
  ) %>% 
  separate(Pct,into = c("Pct1","Pct2") ,sep="-") %>% 
  mutate(Pct = ifelse(is.na(Pct2),Pct1,(as.numeric(Pct1)+as.numeric(Pct2))/2)) %>% 
  select(-Pct1,-Pct2) %>% 
  mutate(Pct = as.numeric(Pct)) %>% 
  filter(!is.na(Pct)) %>% 
  mutate(
    Methode = ifelse(
      str_detect(Befragte,"TOM"),"TOM",ifelse(
        str_detect(Befragte,"T"),"T",ifelse(
          str_detect(Befragte,"O"),"O",NA)
        )),
    Befragte = str_remove(Befragte,"[A-Z]+"),
    Befragte = str_remove(Befragte," • "),
    Befragte_RAW = Befragte,
    Befragte = ifelse(nchar(Befragte_RAW) <= 5,Befragte_RAW,0),
    Befragte = str_remove(Befragte,"[.]")
  ) %>%
  #df_wahlrecht_
  filter(
    !str_detect(Befragte,"[?]"),
    !str_detect(Befragte,"[;]"),
    Befragte != "",
    !str_detect(Befragte,"[a-z]"),
    !str_detect(Befragte,"[A-Z]"),
    !str_detect(Befragte,"•")
  ) %>% 
  mutate(
    Befragte = as.numeric(Befragte),
    Befragte_clean = str_remove(Befragte_RAW,"([0-9]|[?]){2}[.]([0-9]|[?]){2}[.]–([0-9]|[?]){2}[.]([0-9]|[?]){2}[.]"),
    Befragte_clean = str_remove(Befragte_clean,"([0-9]|[?]){2}[.]([0-9]|[?]){2}[.]–([0-9]|[?]){2}[.]([0-9]|[?]){2}"),
    Befragte_clean = str_remove(Befragte_clean,"([0-9]|[?]){2}[.]([0-9]|[?]){2}[.]–([0-9]|[?]){2}[.]([0-9]|[?]){2}[.]"),
    Befragte_clean = str_remove(Befragte_clean,"([0-9]|[?]){2}[.]([0-9]|[?]){2}[.]–([0-9]|[?]){2}[.]([0-9]|[?]){2}"),
    Befragte_clean = str_remove(Befragte_clean,"([0-9]|[?]){2}[.]([0-9]|[?]){2}[.]"),
    Befragte_clean = str_remove(Befragte_clean,"[?]{2}[.]"),
    Befragte_clean = str_remove(Befragte_clean,"[?]+"),
    Befragte_clean = str_remove(Befragte_clean,"	• "),
    Befragte_clean = str_remove(Befragte_clean,"• ")
  ) %>% 
  filter(Befragte_clean != "") %>% 
  mutate(
    Befragte_clean = str_remove(Befragte_clean,"(~|≈|•|>)+[[:blank:]]*"),
    Befragte_clean = str_remove(Befragte_clean,"-([0-9]|[?]){2}[.]([0-9]|[?]){2}[.]"),
    Befragte_clean = str_remove(Befragte_clean,"-([0-9]|[?])[.]([0-9]|[?])[.]"),
    Befragte_clean = str_remove(Befragte_clean,"([0-9]|[?]){2}[.]([0-9]|[?]){1,2}[.](-|–)"),
    Befragte_clean = str_remove(Befragte_clean,"([0-9]|[?]){2}[.]([0-9]|[?]){1,2}(-|–)"),
    Befragte_clean = str_remove(Befragte_clean,"([a-z]|[A-Z])+([a-z]|[A-Z]|[0-9]|\\s)*"),
    Befragte_clean = paste0(str_remove(str_sub(Befragte_clean,1,1),"\\s"),str_sub(Befragte_clean,2)),
    #Befragte_clean = ifelse(str_sub(Befragte_clean,1,1) == " ",str_sub(Befragte_clean,2),Befragte_clean),
    Befragte_clean = str_remove(Befragte_clean,"([,]|\\s|-|–|ä|[/])+([A-Z]|[a-z]|ä|[0-9]|\\s)*"),
    Befragte_clean = str_remove(Befragte_clean,"(2010)|(2002)|(13[.])|(31[.]5[.])"),
    Befragte_clean = str_remove(Befragte_clean,"(\'|[A-Z]|[a-z])+"),
    Befragte_clean = str_remove(Befragte_clean,"’03")
  ) %>% 
  mutate(
    Befragte_clean = str_remove(Befragte_clean,"[.]"),
    Befragte_clean = str_remove(Befragte_clean,"\\s"),
    Befragte_clean = as.numeric(Befragte_clean)
    ) %>% 
  mutate(
    Befragte = Befragte_clean
    ) %>% 
  select(Land,Institut,Methode,Datum,Befragte,Partei,Pct) ->
  df_wahlrecht_

df_wahlrecht <- df_wahlrecht_

save(df_wahlrecht,file = "data/df_wahlrecht_clean.Rdata")
rm(df_wahlrecht_)
