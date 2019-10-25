# _df_ contains all Polls and corresponding election results
# _Date_ is the data the poll was released
# _Vote_Date_ is the date of the next election to the poll for the corresponding parliament.
# _Distance_ is the number of days between Poll Date and Election Date.
# _Delta_ is the 95% confidence intervall margin.
# _Abs_Error_ is the difference between poll and election, for a single party, in percentage points
# _Rel_Error_ is _Abs_Error_ divided with _Delta_
# _Abs_Poll_Error_ is the _Abs_Error_ of a poll, aggregated over all parties in the poll.

df %>% 
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

# How good are polls, by distance to election day?
df_bnchmrk %>% 
  # only polls in the final year to the election are considered, and also only Polls with a sample size of more than 900.
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

# How good are polls, overall?
df_bnchmrk_polls %>% 
  filter(year(Vote_Date) >= 2000) %>% 
  mutate(Mean_Abs_Poll_Error = Abs_Poll_Error %>% mean()) %>% 
  select(Mean_Abs_Poll_Error) %>% 
  unique()

# How good are polls, by the number of weeks to election day?
df_bnchmrk_polls %>% 
  filter(year(Vote_Date) >= 2000) %>% 
  mutate(Week = as.numeric(Distance) %/% 7) %>% 
  group_by(Week) %>% 
  mutate(Mean_Abs_Poll_Error = Abs_Poll_Error %>% mean()) %>% 
  select(Week,Mean_Abs_Poll_Error) %>% 
  unique() %>% 
  arrange(Week) %>% 
  View()

# How good are polls, by year?
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

# How good are polls, by pollster?
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