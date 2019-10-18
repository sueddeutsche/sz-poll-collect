# _df_ enthält Umfrageergebnisse und die dazugehörigen Wahlergebnisse.
# _Date_ ist das Datum der Umfrage, _Vote_Date_ das Datum der darauffolgenden Wahl für das jeweilige Parlament.
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
  left_join(elections) %>% 
  mutate(
    n = as.numeric(n),
    Distance = Vote_Date - Date,
    Delta = sqrt(Pct/100 * (1 - Pct/100)/n) * 1.96 * 100,
    Error = abs(Vote_Pct - Pct) / Delta
  ) ->
  df_bnchmrk
  
# Ein paar explorative Plots.
# Verhältnis von _Distance_ und _Error_
df_bnchmrk %>% 
  ggplot(aes( x = -Distance, y = Error)) +
  geom_point(alpha = .2) +
  xlim(c(-365,0)) +
  geom_hline(yintercept = 1, color = 'blue') +
  geom_smooth()

# Zoom in: Nur Umfragen, die in den letzten 14 Tagen vor der Wahl erschienen sind.
df_bnchmrk %>% 
  ggplot(aes( x = -Distance, y = Error)) +
  geom_point(alpha = .2) +
  xlim(c(-14,0)) +
  geom_hline(yintercept = 1, color = 'blue') +
  geom_smooth()

# Performen die sogenannten "seriösen" Institute besser?
# Hier nennen wir sie Legacy Pollsters. 
df_bnchmrk %>% 
  mutate(is.legacypollster = Institute_ID %in% c('1','2','4','5','6','14')) ->
  df_bnchmrk

df_bnchmrk %>% 
  ggplot(aes( x = -Distance, y = Error, color = is.legacypollster)) +
  geom_point(alpha = .2) +
  xlim(c(-14,0)) +
  geom_hline(yintercept = 1, color = 'blue') +
  geom_smooth()

# Ja, sie sind besser!
  
df_bnchmrk %>% 
  filter(
    Distance <= 14,
    ) %>%
  mutate(is.good = ifelse(Error < 1,'good.poll','bad.poll')) %>% 
  group_by(is.legacypollster) %>% 
  mutate(N= n()) %>% 
  group_by(is.legacypollster,is.good) %>% 
  mutate(share = n() / N) %>% 
  select(is.legacypollster,N,is.good,share) %>% 
  unique() %>% 
  ungroup() %>% 
  spread(key = is.good,value = share)