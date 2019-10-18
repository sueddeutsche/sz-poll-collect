germanpolls <-
  germanpolls("de") %>% 
  rbind(germanpolls("by"))
  
germanpolls("sn") %>% 
  View()
# de,Deutschland
# by,Bayern
# he,Hessen
# hb,Bremen
# ni,Niedersachsen
# sn,Sachsen
# th,Thüringen

# You can't get polling data for:
# eu, European Union
# be,Berlin
# bb,Brandenburg
# bw,Baden-Württemberg
# hh,Hamburg
# mv,Mecklenburg-Vorpommern
# nw,Nordrhein-Westfalen
# rp,Rheinland-Pfalz
# sh,Schleswig-Holstein
# sl,Saarland
# st,Sachsen-Anhalt