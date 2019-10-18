df_vote.dates <-
  tibble(
    Poll_ID = character(),
    Vote_Date = date()
  )

for (i in c(1:nrow(df_polls))){
  poll <- df_polls[i,]
  poll.id <- poll[[1,1]]
  parliament <- poll[[1,3]]
  parliament.elections <-
    elections %>% 
    filter(Parliament_ID == parliament)
  poll.date <- as_date(poll[[1,2]])
  vote.date <- NA
  if (poll.date < max(parliament.elections$Vote_Date)){
    date <- poll.date + 1
    election_found <- F
    while (election_found == F) {
      if (date %in% parliament.elections$Vote_Date){
        vote.date <- date
        election_found <- T
      } 
      date <- date + 1
    }
  }
  data <-
    tibble(
      Poll_ID = poll.id,
      Vote_Date = vote.date
    )
  
  df_vote.dates <-
    df_vote.dates %>% 
    rbind(data)
}

df_vote.dates %>%
  mutate(Vote_Date = as_date(Vote_Date)) ->
  df_vote.dates

df_polls %>%
  left_join(df_vote.dates) ->
  df_polls

df %>%
  left_join(select(df_polls,Poll_ID,Vote_Date)) ->
  df

elections %>% 
  mutate(Parliament_ID = as.character(Parliament_ID)) ->
  elections

rm(data,df_polls,df_vote.dates,parliament.elections,poll,date,election_found,election.date,i,parliament,poll.date,poll.id,vote.date)