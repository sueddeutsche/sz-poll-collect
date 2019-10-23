elections <-
  read_csv("data/elections_2016_2019.csv")

df %>% 
  select(Poll_ID,Date,Parliament_ID,Parliament_Name) %>% 
  unique() ->
  df_polls

df %>% 
  select(Party_ID,Party_Name) %>% 
  unique() ->
  df_parties

elections %>% 
  left_join(read_tsv("data/helper/match_parliament.tsv")) %>% 
  left_join(df_parties, by = c('Partei' = 'Party_Name')) %>% 
  select('Vote_Date' = Wahltag,Parliament_ID,Parliament_Name,Party_ID,'Party_Name' = Partei, 'Vote_Pct' = Anteil) ->
  elections

elections -> df_elections

rm(df_parties,elections)