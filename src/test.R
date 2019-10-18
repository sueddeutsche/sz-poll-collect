"http://www.wahlrecht.de/umfragen/politbarometer/politbarometer-2009.htm" %>% 
  read_html() %>% 
  html_node("table.wilko") %>% 
  html_table(fill = T) ->
  t

t[[1,1]] <- "Datum"
t[[1,2]] <- "X1"
names(t) <- as.vector(t[1,])

t %>% 
  select(-X1) %>% 
  select(Datum, Befragte, Zeitraum,everything()) %>% 
  gather(key = "Partei", value = "Pct", 4:ncol(.)) ->
  t

t %>% 
  select(Datum) %>% 
  mutate(Datum_Check = dmy(Datum)) %>% 
  View()