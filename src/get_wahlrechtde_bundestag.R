url <- "http://www.wahlrecht.de/umfragen/index.htm"

url %>% 
  read_html() %>% 
  html_node('table.wilko') %>% 
  html_node("thead") %>% 
  html_nodes("a") %>% 
  map(xml_attrs) %>% 
  map_df(~as.list(.)) ->
  ilinks

ilinks <- ilinks$href

for (i in c(1:length(ilinks))){
  institute <- ilinks[i]
  url <- paste0("http://wahlrecht.de/umfragen/",institute)
  url %>% 
    read_html() %>% 
    html_node("p.navi") %>% 
    html_nodes("a") %>% 
    map(xml_attrs) %>% 
    map_df(~as.list(.)) ->
    jlinks
  
  jlinks <- paste0("http://www.wahlrecht.de/umfragen/",jlinks$href)
  
  jlinks <- c(url,links)
  
  table <-
    tibble(
      'Datum' = character(),
      'Befragte' = character(),
      'Zeitraum' = character(),
      'Partei' = character(),
      'Pct' = character()
    )
  
  for (j in c(1:length(jlinks))){
    url <- jlinks[j]
    url %>% 
    read_html() %>% 
      html_node("table.wilko") %>% 
      html_table(fill = T) %>% 
      as_tibble(.name_repair = "unique") ->
      t
    
    t[[1,1]] <- "Datum"
    t[[1,2]] <- "X1"
    names(t) <- as.vector(t[1,])
    
    t %>% 
      select(-X1) %>% 
      select(Datum, Befragte, Zeitraum,everything()) %>% 
      gather(key = "Partei", value = "Pct", 4:ncol(.)) ->
      t
    table %>% 
      rbind(t) ->
      table
  }
  table %>% 
    mutate(
      Institut = institute,
      Land = "Bundestag"
    ) %>% 
    select(Land,Institut,Datum,Befragte,Partei,Pct) ->
    table
  df.wahlrecht %>% 
    rbind(table) ->
    df.wahlrecht
}
