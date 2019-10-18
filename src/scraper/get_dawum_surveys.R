dawum$Surveys ->
  dawum.surveys

df <-
  tibble(
    'Date' = character(),
    'Date_Start' = character(),
    'Date_End' = character(),
    'n' = character(),
    'Parliament_ID' = character(),
    'Institute_ID' = character(),
    'Tasker_ID' = character(),
    'Party' = character(),
    'Pct' = numeric()
  )

for (i in c(1:length(dawum.surveys))){
  data.list <-
    dawum.surveys[i][[1]]
  
  data <-
    tibble(
      'Date' =  data.list[[1]],
      'Date_Start' = data.list[[2]][[1]],
      'Date_End' = data.list[[2]][[2]],
      'n' = data.list[[3]],
      'Parliament_ID' = data.list[[4]],
      'Institute_ID' = data.list[[5]],
      'Tasker_ID' = data.list[[6]]
    )
  
  results <- data.list[[7]]
  
  results %>% as_tibble() ->
    results
  
  names(results) <- paste0("party_",names(results))
  
  data <-
    cbind(data,results) %>% 
    gather(key = "Party", value = "Pct", 8:ncol(.)) %>% 
    mutate(Poll_ID = names(dawum.surveys[i]))
  
  df %>% 
    rbind(data) ->
    df
}

df %>% 
  separate(Party, into = c("Party_X","Party_ID"), sep = "_") %>% 
  select(-Party_X) %>% 
  select(Poll_ID,everything()) ->
  df
