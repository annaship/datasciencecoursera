library(ggplot2)
library(dplyr)

file_destination <- "./data/"

download_data = function() {
  file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  if(!file.exists("./data")){ dir.create("./data") }
  temp <- tempfile()
  download.file(file_url, temp)
  
  unzip(temp, exdir = file_destination)
  unlink(temp)
}

# ===
# 1) Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

clean_year <- function(NEI) {
  y <- as.Date(as.character(NEI$year), "%Y")
  NEI$year <- as.factor(y)
}

plot1 <- function(NEI) {
  res1 <- tapply(NEI$Emissions, NEI$year, sum)
  res2 <- transform(res1, year = rownames(res1))
  names(res2) <- (c("Total.Emission", "Year"))
  with(res2, plot(year, Total.Emission, ylab = "Total Emissions", xlim = c(1998, 2009) ))
}
# ===
# 2) Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (\color{red}{\verb|fips == "24510"|}fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

plot2 <- function(NEI) {
  balt <- subset(NEI, fips == "24510")
  plot1(balt)
  title(main = "Total emissions in the Baltimore City")
}
  
# ===
# 3) Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

plot3 <- function(NEI) {
  balt <- subset(NEI, fips == "24510")
  qplot(as.factor(year), Emissions, data = balt, facets = . ~ as.factor(type)) + labs(x = "Years", title = "Emissions in the Baltimore City")
}

# ===
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# > length(unique(grep("coal", SCC$SCC.Level.Four, ignore.case = T, value = T )))
# > length(unique(grep("combustion", SCC$SCC.Level.Four, ignore.case = T, value = T ))) 44
# > length(unique(grep("combustion", SCC$Short.Name, ignore.case = T, value = T ))) 46
# > comb_coal <- unique(grep("coal", comb, ignore.case = T, value = T )) 8

plot4 <- function(NEI, SCC) {

  coal_combustion_df <- SCC[grepl("(coal.*combustion)|(combustion.*coal)", SCC$Short.Name, ignore.case = T),]
  
  coal_combustion_df_nei <- merge(NEI, coal_combustion_df, by = "SCC")

   qplot(as.factor(year), Emissions, data = coal_combustion_df_nei, facets = . ~ as.factor(SCC)) + labs(x = "Years", title = "Emissions from coal combustion-related sources")
   
}

# ===
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

plot5 <- function(NEI, SCC) {
  
  vehicle_df <- SCC[grepl("Motor Vehicl", SCC$Short.Name, ignore.case = T),]
  
  merge(NEI, vehicle_df, by = "SCC") %>%
    subset(fips == "24510") -> vehicle_df_nei_balt
  
  qplot(as.factor(year), Emissions, data = vehicle_df_nei_balt, facets = . ~ as.factor(SCC)) + labs(x = "Years", title = "Emissions from coal combustion-related sources")
}

# ===
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (\color{red}{\verb|fips == "06037"|}fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?


# __main__

# download_data()
# read_files

# NEI <- readRDS("data/summarySCC_PM25.rds")
# SCC <- readRDS("data/Source_Classification_Code.rds")

# clean_year(NEI)
# plot1(NEI)
# plot2(NEI)
# plot3(NEI)
# plot4(NEI, SCC)
# plot5(NEI, SCC)