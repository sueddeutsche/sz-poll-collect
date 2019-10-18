read_html("http://www.wahlrecht.de/umfragen/landtage/index.htm") %>% 
  html_nodes("table.wilko") %>% 
  html_nodes("th.li") %>% 
  html_nodes("a") %>% 
  map(xml_attrs) %>% 
  map_df(~as.list(.)) ->
  links

links <- paste0("http://www.wahlrecht.de/umfragen/landtage/",links$href)

links <- c(links[1:4],links[6:16])

df.wahlrecht <-
  tibble(
    'Institut' = character(),
    'Auftraggeber' = character(),
    'Befragte'= character(),
    'Datum' = character(),
    'Partei' = character(),
    'Pct' = character(),
    'Land' = character()
  )

for (i in c(1:length(links))){
  url <- links[i]
  read_html(url) %>% 
    html_nodes("table.wilko") ->
    tables
  
  tables[[1]] %>% 
    html_table(fill = T) %>% 
    gather(key = "Partei", value = "Pct", 6:ncol(.)) %>% 
    select(-5) ->
    table
  names(table) <- c("Institut","Auftraggeber","Befragte","Datum","Partei","Pct")
  j <- 2
  
  while (j <= length(tables)){
    tables[[j]] %>% 
      html_table(fill = T) %>% 
      gather(key = "Partei", value = "Pct", 6:ncol(.)) %>% 
      select(-5) ->
      t
    names(t) <- c("Institut","Auftraggeber","Befragte","Datum","Partei","Pct")
    table %>% 
      rbind(t) ->
      table
    names(table) <- c("Institut","Auftraggeber","Befragte","Datum","Partei","Pct")
    j <- j + 1
  }
  table %>% 
    mutate(Land = url) %>% 
    mutate(
      Land = str_replace(Land,"http://www.wahlrecht.de/umfragen/landtage/",""),
      Land = str_replace(Land,".htm","")
    ) ->
    table
  names(table) <- c("Institut","Auftraggeber","Befragte","Datum","Partei","Pct","Land")
  df.wahlrecht %>% 
    rbind(table) ->
    df.wahlrecht
}

# Sonderfall Bremen
url <- links[5]
read_html(url) %>% 
  html_nodes("table.wilko") ->
  tables

tables[[1]] %>% 
  html_table(fill = T) %>% 
  as_tibble(.name_repair = "unique") %>% 
  select(1,2,3,5,7,9,11,13,15,17,19) %>% 
  gather(key = "Partei", value = "Pct", 5:ncol(.)) ->
  table
names(table) <- c("Institut","Auftraggeber","Befragte","Datum","Partei","Pct")
j <- 2
while (j <= length(tables)){
  tables[[j]] %>% 
    html_table(fill = T) %>%
    as_tibble(.name_repair = "unique") %>%
    select(1,2,3,5,7,9,11,13,15,17,19) %>% 
    gather(key = "Partei", value = "Pct", 5:ncol(.)) ->
    t
  names(t) <- c("Institut","Auftraggeber","Befragte","Datum","Partei","Pct")
  table %>% 
    rbind(t) ->
    table
  names(table) <- c("Institut","Auftraggeber","Befragte","Datum","Partei","Pct")
  j <- j + 1
}
table %>% 
  mutate(Land = "bremen") ->
  table

df.wahlrecht %>% 
  rbind(table) ->
  df.wahlrecht

rm(t,table,tables,url,links,i,j)