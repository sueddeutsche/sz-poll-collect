df.parliaments <-
  tibble(
    'Parliament_ID' = character(),
    'Parliament_Name' = character()
  )

for (i in c(1:length(dawum$Parliaments))){
  data <-
    tibble(
      'Parliament_ID' = names(dawum$Parliaments[i]),
      'Parliament_Name' = dawum$Parliaments[[i]]$Shortcut
    )
  df.parliaments <-
    df.parliaments %>% 
    rbind(data)
}

df.institutes <-
  tibble(
    'Institute_ID' = character(),
    'Institute_Name' = character()
  )

for (i in c(1:length(dawum$Parliaments))){
  data <-
    tibble(
      'Institute_ID' = names(dawum$Institutes[i]),
      'Institute_Name' = dawum$Institutes[[i]]$Name
    )
  df.institutes <-
    df.institutes %>% 
    rbind(data)
}

df.institutes <-
  tibble(
    'Institute_ID' = character(),
    'Institute_Name' = character()
  )

for (i in c(1:length(dawum$Institutes))){
  data <-
    tibble(
      'Institute_ID' = names(dawum$Institutes[i]),
      'Institute_Name' = dawum$Institutes[[i]]$Name
    )
  df.institutes <-
    df.institutes %>% 
    rbind(data)
}

df.taskers <-
  tibble(
    'Tasker_ID' = character(),
    'Tasker_Name' = character()
  )

for (i in c(1:length(dawum$Taskers))){
  data <-
    tibble(
      'Tasker_ID' = names(dawum$Taskers[i]),
      'Tasker_Name' = dawum$Taskers[[i]]$Name
    )
  df.taskers <-
    df.taskers %>% 
    rbind(data)
}

df.parties <-
  tibble(
    'Party_ID' = character(),
    'Party_Name' = character()
  )

for (i in c(1:length(dawum$Parties))){
  data <-
    tibble(
      'Party_ID' = names(dawum$Parties[i]),
      'Party_Name' = dawum$Parties[[i]]$Shortcut
        )
      
  df.parties <-
    df.parties %>% 
    rbind(data)
}