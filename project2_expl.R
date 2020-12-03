library(ggplot2)
library(dplyr)
library(gridExtra)

file_destination <- "./data/"

download_data = function() {
  file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  if(!file.exists("./data")){ dir.create("./data") }
  temp <- tempfile()
  download.file(file_url, temp)
  
  unzip(temp, exdir = file_destination)
  unlink(temp)
}

clean_year <- function(NEI) {
  y <- as.Date(as.character(NEI$year), "%Y")
  NEI$year <- as.factor(y)
}

# ===
# 1) Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

plot1 <- function(NEI, title = "") {
  res1 <- tapply(NEI$Emissions, NEI$year, sum)
  res2 <- transform(res1, year = rownames(res1))
  names(res2) <- (c("Total.Emission", "Year"))
  with(res2, plot(year, Total.Emission, ylab = "Total Emissions", xlim = c(1998, 2009) ))
  title(main = title)
}
# ===
# 2) Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (\color{red}{\verb|fips == "24510"|}fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

plot2 <- function(NEI) {
  balt <- subset(NEI, fips == "24510")
  plot1(balt, "Total emissions in the Baltimore City")
}
  
# ===
# 3) Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

plot3 <- function(NEI) {
  balt <- subset(NEI, fips == "24510")
  
  p3 <- qplot(as.factor(year), Emissions, 
        data = balt, 
        facets = . ~ as.factor(type)) + 
    labs(x = "Years", title = "Emissions in the Baltimore City by Type")
  print(p3)
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

  p4 <- qplot(as.factor(year), Emissions, 
         data = coal_combustion_df_nei, 
         facets = . ~ as.factor(SCC)) + 
     labs(x = "Years", title = "Emissions from coal combustion-related sources")
   print(p4)
   
}

# ===
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

plot5 <- function(NEI, SCC) {
  
  vehicle_df <- SCC[grepl("Motor Vehicl", SCC$Short.Name, ignore.case = T),]
  
  merge(NEI, vehicle_df, by = "SCC") %>%
    subset(fips == "24510") -> vehicle_df_nei_balt
  
  p5 <- qplot(as.factor(year), Emissions, 
        data = vehicle_df_nei_balt, 
        facets = . ~ as.factor(SCC)) + 
    labs(x = "Years", title = "Emissions from motor vehicle sources for Baltimore")
  print(p5)

}

# ===
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (\color{red}{\verb|fips == "06037"|}fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

plot6_scaled <- function(NEI, SCC) {
  
  vehicle_df <- SCC[grepl("Motor Vehicl", SCC$Short.Name, ignore.case = T),]
  
  vehicle_df_nei <- merge(NEI, vehicle_df, by = "SCC")
  vehicle_df_nei_Balt <- subset(vehicle_df_nei, fips == "24510")
  vehicle_df_nei_LA <- subset(vehicle_df_nei, fips == "06037")
  
  all_years <- as.factor(year)
  p1 = qplot(as.factor(year), Emissions, data = vehicle_df_nei_Balt) +
    labs(x = "Years", title = "Motor vehicle emissions in Baltimore") + 
    scale_y_continuous(limits = c(10, 66)) +
    scale_x_discrete(name = "Years", limits = all_years)
  
  #+ geom_point()
     
  p2 = qplot(as.factor(year), Emissions, data = vehicle_df_nei_LA) + 
    labs(x = "Years", title = "Motor vehicle emissions in Los Angeles County, CA") +
    scale_y_continuous(limits = c(10, 66))
  
  grid.arrange(p1, p2, nrow = 1)
  
}

plot6 <- function(NEI, SCC) {
  
  vehicle_df <- SCC[grepl("Motor Vehicl", SCC$Short.Name, ignore.case = T),]
  
  vehicle_df_nei <- merge(NEI, vehicle_df, by = "SCC")
  vehicle_df_nei_Balt <- subset(vehicle_df_nei, fips == "24510")
  vehicle_df_nei_LA <- subset(vehicle_df_nei, fips == "06037")
  
  all_years <- as.factor(year)
  p1 = qplot(as.factor(year), Emissions, data = vehicle_df_nei_Balt) +
    labs(x = "Years", title = "Motor vehicle emissions in Baltimore") + 
    scale_x_discrete(name = "Years", limits = all_years)
  
  p2 = qplot(as.factor(year), Emissions, data = vehicle_df_nei_LA) + 
    labs(x = "Years", title = "Motor vehicle emissions in Los Angeles County, CA")

  grid.arrange(p1, p2, nrow = 1)
  
}

# __main__

#download_data()

#NEI <- readRDS("data/summarySCC_PM25.rds")
#SCC <- readRDS("data/Source_Classification_Code.rds")

clean_year(NEI)

png(file = "plot1.png")
plot1(NEI, "Total emissions in the US")
dev.off()

png(file = "plot2.png")
plot2(NEI)
dev.off()

png(file = "plot3.png")
plot3(NEI)
dev.off()

png(file = "plot4.png")
plot4(NEI, SCC)
dev.off()

png(file = "plot5.png")
plot5(NEI, SCC)
dev.off()

png(file = "plot6.png")
plot6(NEI, SCC)
dev.off()
