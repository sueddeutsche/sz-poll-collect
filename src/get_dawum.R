read_json("data/dawum.json", simplifyVector = T) ->
  dawum

source("src/get_dawum_surveys.R")
source("src/get_dawum_meta.R")

df %>% 
  left_join(df.institutes) %>% 
  left_join(df.parliaments) %>% 
  left_join(df.taskers) %>% 
  left_join(df.parties) %>% 
  unique() ->
  df

df %>% 
  mutate(Party_Name= str_replace(Party_Name,"CDU/CSU","CDUCSU")) %>% 
  mutate(Party_Name = str_replace(Party_Name,'Grüne','Gruene')) %>% 
  mutate(Party_Name = str_replace(Party_Name,'BVB/FW','FW')) %>% 
  mutate(Party_Name = ifelse(Party_Name %in% c("CDUCSU","CDU","CSU"),'CDUCSU',Party_Name)) %>%
  mutate(Party_ID = ifelse(Party_Name %in% c("CDUCSU","CDU","CSU"),'1',Party_ID)) %>% 
  mutate(Party_ID = ifelse(Party_ID %in% c("1","2","3","4","5","7"),Party_ID,'0')) %>% 
  mutate(Party_Name = ifelse(Party_ID %in% c("1","2","3","4","5","7"),Party_Name,'Sonstige')) %>% 
  as_tibble() %>% 
  mutate(
    Date = ymd(Date),
    Date_Start = ymd(Date_Start),
    Date_End = ymd(Date_End)
    ) ->
  df
  
rm(df.institutes,df.taskers,df.parliaments,df.parties)
rm(data,results,data.list,dawum.surveys,i)