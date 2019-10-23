df ->
  df_full
save(df_full, file = "data/df_full.Rdata")
rm(df_full)

df %>%
  select(
    Poll_ID,Date,Vote_Date,Parliament_ID,Parliament_Name,Institute_ID,Institute_Name,n,Party_Name,Pct
  ) %>% 
  mutate(Parliament_ID = as.character(Parliament_ID)) ->
  df
