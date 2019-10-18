url <- paste0("http://wahlrecht.de/umfragen/",institute)
url %>% 
  read_html() %>% 
  html_node("p.navi") %>% 
  html_nodes("a") %>% 
  map(xml_attrs) %>% 
  map_df(~as.list(.)) ->
  jlinks

if (nrow(jlinks) > 0){
  jlinks <- paste0("http://www.wahlrecht.de/umfragen/",jlinks$href)
} else{
  jlinks <- c()
}

jlinks <- c(url,jlinks)
