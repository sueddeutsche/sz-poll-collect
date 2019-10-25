# _df_ enthält Umfrageergebnisse und die dazugehörigen Wahlergebnisse.
# _Date_ ist das Datum der Umfrage
# _Vote_Date_ ist das Datum der darauffolgenden Wahl für das jeweilige Parlament.
# _Distance_ ist der Abstand zwischen Umfrage und Wahl in Tagen.
# _Delta_ ist die Fehlertoleranz des 95-Prozent-Konfidenzintervalls der jeweiligen Umfrage.
# _Error_ ist die Differenz zwischen Umfrage und Wahlergebnis - ausdgerückt als Vielfaches von Delta.
# Das ist so gewählt, weil es zum imho wichtigsten Qualitätsindikator passt:
# Liegt die Umfrage um weniger als ihre Fehlertoleranz daneben?
# Error < 1: good poll
# Error > 1: bad poll
# Error > 2: really bad poll

df %>% 
#  filter(Parliament_Name != "Bundestag") %>% 
  filter(
    !is.na(Vote_Date),
    Party_Name != "Sonstige"
    ) %>% 
  left_join(df_elections) %>% 
  mutate(
    n = as.numeric(n),
    Distance = Vote_Date - Date,
    Delta = sqrt(Pct/100 * (1 - Pct/100) / n) * 1.96 * 100,
    Abs_Error = abs(Vote_Pct - Pct), 
    Rel_Error = Abs_Error / Delta
  ) %>% 
  group_by(Poll_ID) %>% 
  mutate(
    Abs_Poll_Error = mean(Abs_Error),
    Rel_Poll_Error = mean(Rel_Error)
    ) %>%
  ungroup() ->
  df_bnchmrk

df_bnchmrk %>% 
  filter(Distance <= 365, n > 900) %>% 
  select(
    Poll_ID,Date,Vote_Date,Distance,Parliament_ID,Parliament_Name,Institute_ID,Institute_Name,
    n,Abs_Poll_Error
    ) %>% 
  unique() %>% 
  mutate(Level = ifelse(Parliament_Name == "Bundestag","Bund","Land"))  ->
  df_bnchmrk_polls

df_bnchmrk_polls %>% 
  ggplot(aes(x = -Distance, y = Abs_Poll_Error)) +
  geom_point(aes(color = Level), alpha = 0.2) +
  geom_smooth(method = "loess") +
  theme_minimal() + 
  ggsave("img/fehler_nach_tagen.svg", width = 300, height = 200, units = "mm")

df_bnchmrk_polls %>% 
  filter(year(Vote_Date) >= 2000) %>% 
  mutate(Mean_Abs_Poll_Error = Abs_Poll_Error %>% mean()) %>% 
  select(Mean_Abs_Poll_Error) %>% 
  unique()

df_bnchmrk_polls %>% 
  filter(year(Vote_Date) >= 2000) %>% 
  mutate(Week = as.numeric(Distance) %/% 7) %>% 
  group_by(Week) %>% 
  mutate(Mean_Abs_Poll_Error = Abs_Poll_Error %>% mean()) %>% 
  select(Week,Mean_Abs_Poll_Error) %>% 
  unique() %>% 
  arrange(Week) %>% 
  View()

df_bnchmrk_polls %>% 
  filter(Distance <= 30) %>% 
  mutate(
    Year = year(Vote_Date)
    ) %>% 
  group_by(Year) %>% 
  mutate(Abs_Mean_Poll_Error = mean(Abs_Poll_Error)) %>% 
  select(Year,Abs_Mean_Poll_Error) %>% 
  unique() %>%
  filter(Year >= 2000) ->
  df_bnchmrk_years
  
df_bnchmrk_years %>% 
  write_csv("img/fehler_nach_jahren.csv")

df_bnchmrk_years %>% 
ggplot(aes(x = Year, y = Abs_Mean_Poll_Error)) +
  geom_col() +
  ggsave("img/fehler_nach_jahren.svg")

df_bnchmrk_polls %>% 
  filter(Distance <= 30) %>% 
  group_by(Institute_ID) %>% 
  mutate(n = n(), 
         Mean_Abs_Poll_Error = Abs_Poll_Error %>% mean() %>% round(2)
         ) %>% 
  select(Institute_ID,Institute_Name,n,Mean_Abs_Poll_Error) %>% 
  unique() %>% 
  filter(n > 20) %>% 
  arrange(desc(Mean_Abs_Poll_Error)) ->
  df_bnchmrk_pollsters

df_bnchmrk_pollsters$Institute_Name <- 
  factor(df_bnchmrk_pollsters$Institute_Name, 
         levels = df_bnchmrk_pollsters$Institute_Name[order(-df_bnchmrk_pollsters$Mean_Abs_Poll_Error)])

df_bnchmrk_pollsters %>% 
  ungroup() %>% 
  select(Institute_Name,Mean_Abs_Poll_Error) %>% 
  write_csv("img/fehler_nach_institut.csv")

df_bnchmrk_pollsters %>% 
  ggplot(aes(x = Institute_Name, y = Mean_Abs_Poll_Error)) +
  geom_col() +
  coord_flip() +
  theme_minimal() +
  ggsave("img/fehler_nach_instituten.svg")