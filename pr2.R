filt1 <- with(storm_data_csv, FATALITIES >= mean(FATALITIES, na.rm = T))
filt2 <- with(storm_data_csv, INJURIES >= mean(INJURIES, na.rm = T))

order(storm_data_csv$FATALITIES, decreasing = T) %>% head(10) -> fat10

order(storm_data_csv$INJURIES, decreasing = T) %>% head(10) -> inj10

filter(storm_data_csv, FATALITIES %in% fat10) %>% head
       
        %in% fat10 | INJURIES %in% inj10) %>% 
  select(STATE__, STATE, EVTYPE, FATALITIES, INJURIES) %>%
  group_by(EVTYPE) -> new_data_health
  

new_data <- filter(storm_data_csv, filt1 | filt2)
new_data %>%
select(STATE__, STATE, EVTYPE, FATALITIES, INJURIES) %>%
group_by(EVTYPE) -> new_data_health

ggplot(data=df2, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity")
# Use position=position_dodge()
ggplot(data=df2, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity", position=position_dodge())
