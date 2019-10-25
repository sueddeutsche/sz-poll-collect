df_bnchmrk %>% 
  filter(Distance < 15) %>%
  mutate(N = n()) %>% 
  mutate(is.good = Rel_Error < 1) %>% 
  group_by(is.good) %>% 
  mutate(
    n = n(),
    Share = n / N * 100 %>% round()
  ) %>% 
  select(is.good,n,Share) %>% 
  unique()

df_bnchmrk %>% 
  filter(Distance < 15) %>%
  arrange(Rel_Error) ->
  df_bnchmrk_

df_bnchmrk_ %>% 
  mutate(
    Error = Pct - Vote_Pct,
    Mean_Error = Error %>% mean(),
    SD_Error = Error %>% sd()
  ) %>% 
  View()
    