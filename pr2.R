storm_data_csv[order(-storm_data_csv$FATALITIES),] %>% 
  select(FATALITIES) %>%
  head(10) %>%
  {.} -> fat10

storm_data_csv[order(-storm_data_csv$INJURIES),] %>% 
  select(INJURIES) %>%
  head(10) %>%
  {.} -> inj10

storm_data_csv %>%
  filter(FATALITIES >= min(fat10) | INJURIES >= min(inj10) ) %>% 
  select(STATE__, STATE, EVTYPE, FATALITIES, INJURIES) %>%
  group_by(EVTYPE) %>%
  {.} -> new_data_health


storm_data_csv %>%
  filter(FATALITIES >= min(fat10) | INJURIES >= min(inj10) ) %>% 
  select(STATE__, STATE, EVTYPE, fat_inj = FATALITIES) %>%
  transform(health_type = "FATALITIES") %>%
  group_by(EVTYPE) %>%
  {.} -> new_data_fat

storm_data_csv %>%
  filter(FATALITIES >= min(fat10) | INJURIES >= min(inj10) ) %>% 
  select(STATE__, STATE, EVTYPE, fat_inj = INJURIES) %>%
  transform(health_type = "INJURIES") %>%
  group_by(EVTYPE) %>%
  {.} -> new_data_inj

new_data_health <- rbind(new_data_fat, new_data_inj)
new_data_health_un <- unique(new_data_health[,c('EVTYPE','fat_inj','health_type')])

ggplot(data=new_data_health_un, aes(x=EVTYPE, y=fat_inj, fill = health_type)) +
  geom_bar(stat="identity")
ggplot(data=new_data_health_un, aes(x=EVTYPE, y=fat_inj, fill = health_type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  geom_text(aes(label=fat_inj), vjust=1.6, color="white",
            position = position_dodge(0.9), size=3.5)
  
