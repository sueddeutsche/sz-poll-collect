df_bnchmrk %>% 
  ggplot(aes( x = -Distance, y = Error)) +
  geom_point(alpha = .2) +
  xlim(c(-365,0)) +
  geom_hline(yintercept = 1, color = 'blue') +
  geom_smooth()

# Zoom in: Nur Umfragen, die in den letzten 14 Tagen vor der Wahl erschienen sind.
df_bnchmrk %>% 
  filter(is.legacypollster) %>% 
  ggplot(aes( x = Institute_Name, y = Error)) +
  geom_point(aes(color = Parliament_ID %in% c("4","13")), alpha = .1) +
  geom_smooth() #, position = "jitter") +
#  xlim(c(-15,-1)) +
  #geom_hline(yintercept = 1, color = 'blue') +
  #geom_hline(yintercept = 2, color = 'grey') +


df_bnchmrk %>% 
    filter(
      Distance <= 14,
      is.legacypollster
      ) %>% 
    mutate(Year = year(Vote_Date)) %>% 
    group_by(Year) %>% 
    mutate(Error = mean(Error)) %>% 
    select(Year,Error) %>% 
    unique() %>% 
    arrange(Year)
  