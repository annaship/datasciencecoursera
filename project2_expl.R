library(ggplot2)

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
  balt1 <- transform(balt, new_type = as.factor(balt$type), new_year = as.factor(balt$year))
  type1 <- split(balt1, balt1$new_type)
  
  res1 <- tapply(balt1$Emissions, balt1$year, sum)
  res2 <- transform(res1, year = rownames(res1))
  
  qplot(year, Total.Emission, data = res2, facets = . ~ type)
  for (i in seq(length(type1))) {

    names(res2) <- (c("Total.Emission", "Year"))
    with(res2, ggplot(year, Total.Emission, ylab = "Total Emissions", xlim = c(1998, 2009) ))
    title(main = unique(type1[[i]]$type))
  }
  
}

# ===

# __main__

# download_data()
# read_files

# NEI <- readRDS("data/summarySCC_PM25.rds")
# SCC <- readRDS("data/Source_Classification_Code.rds")

# clean_year(NEI)
# plot1(NEI)
# plot2(NEI)
plot3(NEI)