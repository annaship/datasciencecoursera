get_max10 = function(input_data, clmn_name) {
  input_data %>%
    slice_max(order_by = !!as.symbol(clmn_name), n = 10)
}

fat_10_max <- get_max10(storm_data_csv, "FATALITIES")

inj_10_max <- get_max10(storm_data_csv, "INJURIES")

unique_max = function(input_data) {
  input_data %>% 
    aggregate(fat_inj ~ EVTYPE, ., max) %>%
    left_join(input_data) 
}

prepare_for_join = function(input_data, clmn_name) {
  input_data %>% 
    select(EVTYPE, fat_inj = !!as.symbol(clmn_name)) %>%
    transform(health_type = clmn_name) %>%
    group_by(EVTYPE)
}

new_data_inj0 <- prepare_for_join(inj_10_max, "INJURIES")
new_data_fat0 <- prepare_for_join(fat_10_max, "FATALITIES")

# new_data_fat %>% aggregate(fat_inj ~ EVTYPE, ., max) %>%
#   left_join(new_data_fat) %>%
#   {.} -> new_data_fat
# 
new_data_fat <- unique_max(new_data_fat0)
new_data_inj <- unique_max(new_data_inj0)

new_data_health <- rbind(new_data_fat, new_data_inj)

# storm_data_csv[order(-storm_data_csv$FATALITIES),] %>% 
#   select(FATALITIES) %>%
#   head(10) %>%
#   {.} -> fat10
# 
# storm_data_csv[order(-storm_data_csv$INJURIES),] %>% 
#   select(INJURIES) %>%
#   head(10) %>%
#   {.} -> inj10

# storm_data_csv %>%
#   filter(FATALITIES >= min(fat10) | INJURIES >= min(inj10) ) %>% 
#   select(STATE__, STATE, EVTYPE, FATALITIES, INJURIES) %>%
#   group_by(EVTYPE) %>%
#   {.} -> new_data_health
# 
# 
# storm_data_csv %>%
#   filter(FATALITIES >= min(fat10) | INJURIES >= min(inj10) ) %>% 
#   select(STATE__, STATE, EVTYPE, fat_inj = FATALITIES) %>%
#   transform(health_type = "FATALITIES") %>%
#   {.} -> new_data_fat
  
  # group_by(EVTYPE) %>%

# mydf %>%
#   group_by(Sample) %>% # for each unique sample
#   arrange(-total_reads) %>% # order by total_reads DESC
#   slice(1) # select the first row, i.e. with highest total_reads
# 
# aggregate(fat_inj ~ EVTYPE, new_data_fat, max) %>% merge()
# merge(aggregate(fat_inj ~ EVTYPE, new_data_fat, max), new_data_fat)


# storm_data_csv %>%
#   filter(FATALITIES >= min(fat10) | INJURIES >= min(inj10) ) %>% 
#   select(STATE__, STATE, EVTYPE, fat_inj = INJURIES) %>%
#   transform(health_type = "INJURIES") %>%
#   group_by(EVTYPE) %>%
#   {.} -> new_data_inj
# 
# new_data_health <- rbind(new_data_fat, new_data_inj)
# new_data_health_un <- unique(new_data_health[,c('EVTYPE','fat_inj','health_type')])

ggplot(data=new_data_health, aes(x=EVTYPE, y=fat_inj, fill = health_type)) +
  geom_bar(stat="identity")
ggplot(data=new_data_health, aes(x=EVTYPE, y=fat_inj, fill = health_type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  geom_text(aes(label=fat_inj), vjust=1.6, color="white",
            position = position_dodge(0.9), size=3.5) +
  labs(x = "Event type", y = "Total number", title = "Types of events most harmful with respect to population health") + 
    guides(fill=guide_legend(title="Harm type"))
