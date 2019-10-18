df ->
  df_full

df %>%
  select(
    Poll_ID,Date,Vote_Date,Parliament_ID,Parliament_Name,Institute_ID,Institute_Name,n,Party_ID,Party_Name,Pct
  ) ->
  df
