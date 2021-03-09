elections <-
  'https://docs.google.com/spreadsheets/d/19tNX3uvMCwGZM2WpHHWsx9QuxDQqC5BVhz5V-zsVNIg/edit?usp=sharing' %>% 
  googlesheets4::read_sheet(col_types = 'ccnnnnnnnn') %>% 
  as_tibble()

elections <-
  elections %>% 
  mutate(
    Wahltag = Wahltag %>% dmy(),
    Jahr = Wahltag %>% year()) %>% 
  select(Land,Jahr, Wahltag, Wahlbeteiligung, everything()) %>% 
  pivot_longer(names_to = 'Partei', values_to = 'Anteil', 5:ncol(.))

df %>% 
  select(Poll_ID,Date,Parliament_ID,Parliament_Name) %>% 
  unique() ->
  df_polls

df %>% 
  select(Party_Name) %>% 
  unique() ->
  df_parties

elections %>% 
  left_join(read_tsv("data/helper/match_parliament.tsv")) %>% 
  left_join(df_parties, by = c('Partei' = 'Party_Name')) %>% 
  select('Vote_Date' = Wahltag,Parliament_ID,Parliament_Name,'Party_Name' = Partei, 'Vote_Pct' = Anteil) ->
  elections

elections -> df_elections

rm(df_parties,elections)
