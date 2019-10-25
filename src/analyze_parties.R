df %>% 
  filter(
    !is.na(Vote_Date),
    Party_Name != "Sonstige"
  ) %>% 
  left_join(df_elections) %>% 
  mutate(
    n = as.numeric(n),
    Distance = Vote_Date - Date,
    Error = Pct - Vote_Pct,
    Direction = Error %>% sign(),
  ) %>% 
  filter(Distance <= 30, abs(Error) > .5) %>% 
  group_by(Party_Name) %>% 
  mutate(sum = n()) %>% 
  group_by(Party_Name,Direction) %>% 
  mutate(
    n = n(),
    Share = n / sum * 100,
    Share = round(Share)
    ) %>% 
  select(Party_Name,Direction,Share,n) %>% 
  unique() ->
  df_bnchmrk_parties
  
df_bnchmrk_parties %>% 
  select(-n) %>% 
  mutate(Richtung = ifelse(Direction > 0,"überschätzt","unterschätzt")) %>% 
  ungroup() %>% 
  select(-Direction) %>%
  unique() %>% 
  spread(key = Richtung, value = Share) %>% 
  arrange(Party_Name) %>% 
  write_csv("img/fehler_nach_parteien.csv")

df_bnchmrk_parties %>% 
  ggplot(aes(x = Party_Name, y = n, fill = Direction)) +
  geom_col(position = "fill") + 
  coord_flip() + 
  ggsave("img/fehler_nach_parteien.svg")
