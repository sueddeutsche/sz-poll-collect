# Can we predict state elections through federal polls?
# inspiration: https://twitter.com/laurenzennser/status/1220452989397360669?s=20

df_federal_polls <-
  df %>% 
  filter(Institute_ID == '6', Parliament_ID == '0') %>% 
  select(Date,Party_Name,Pct) %>% 
  mutate(Day = as.numeric(Date - ymd('1990-01-01')))

df_state_results <-
  df_elections %>% 
  filter(!(Parliament_ID %in% c('0','17'))) %>% 
  rowwise() %>% 
  mutate(
    Vote_Day = as.numeric(Vote_Date - ymd("1990-01-01")),
    Poll_Day = DescTools::Closest(unique(df_federal_polls$Day),Vote_Day)
    ) %>% 
  left_join(df_federal_polls, by = c('Poll_Day' = 'Day','Party_Name')) %>% 
  group_by(Parliament_ID,Party_Name) %>%
  arrange(Vote_Date) %>% 
  mutate(
    Vote_Pct_Change = Vote_Pct - lag(Vote_Pct),
    Poll_Pct_Change = Pct - lag(Pct),
    Distance = Vote_Date - Date
    ) %>% 
  ungroup()

df_state_results %>%
  filter(Distance < 31, !is.na(Poll_Pct_Change), !is.na(Vote_Pct_Change)) %>% 
  ggplot(aes(x = Poll_Pct_Change, y = Vote_Pct_Change)) +
  geom_point(aes(color = Party_Name)) +
  geom_smooth(method = "lm")


