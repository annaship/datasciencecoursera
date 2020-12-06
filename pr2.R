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
  {.} -> new_data_fat

storm_data_csv %>%
  filter(FATALITIES >= min(fat10) | INJURIES >= min(inj10) ) %>% 
  select(STATE__, STATE, EVTYPE, fat_inj = INJURIES) %>%
  transform(health_type = "INJURIES") %>%
  {.} -> new_data_inj

rbind(new_data_fat, new_data_inj) %>% head(2)


ggplot(data=new_data_health, aes(x=EVTYPE, y=FATALITIES)) +
  geom_bar(stat="identity")
# Use position=position_dodge()
ggplot(data=new_data_health, aes(x=EVTYPE, y=INJURIES)) +
  geom_bar(stat="identity", position=position_dodge())
