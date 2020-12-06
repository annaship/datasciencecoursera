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
  aggregate(fat_inj ~ EVTYPE, ., max) %>%

    left_join() %>%
  group_by(EVTYPE) %>%
  {.} -> new_data_fat

mydf %>%
  group_by(Sample) %>% # for each unique sample
  arrange(-total_reads) %>% # order by total_reads DESC
  slice(1) # select the first row, i.e. with highest total_reads

aggregate(fat_inj ~ EVTYPE, new_data_fat, max) %>% merge()
merge(aggregate(fat_inj ~ EVTYPE, new_data_fat, max), new_data_fat)


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
# TODO:
# 3
# EXCESSIVE HEAT
# 0
# INJURIES
# 13
# EXCESSIVE HEAT
# 67
# FATALITIES
# 14
# EXCESSIVE HEAT
# 74
# FATALITIES
# 17
# EXCESSIVE HEAT
# 99
# FATALITIES
# 20
# EXCESSIVE HEAT
# 135
# INJURIES
