## QUESTION: "Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
## which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
## Which have seen increases in emissions from 1999–2008?"


library(dplyr)
library(ggplot2)


#####################################
## DOWNLOAD AND UNZIP DATA
dir.create("./data", showWarnings = FALSE)

downloadURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"  ## URL for downloading data
downloadedFile <- "./data/exdata_data_NEI_data.zip"  ## path the the downloaded zip file
pm25Emissions <- "./data/summarySCC_PM25.rds"  ## path to the PM2.5 Emissions Data
clfCode <- "./data/Source_Classification_Code.rds"  ## path to the Source Classification Code Table

if (!file.exists(pm25Emissions) || !file.exists(clfCode)) {
    download.file(downloadURL, downloadedFile, method = "curl")
    unzip(downloadedFile, exdir = "./data")
}


#####################################
## LOAD DATA
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")


#####################################
## PREPARE DATA
baltimoreEmissionsByYear <- NEI[NEI$fips == "24510", ] %>% 
    group_by(year, type) %>%
    summarise(sum(Emissions)) %>%
    rename("totalEmissions" = "sum(Emissions)")


#####################################
## PLOT AND SAVE
## construct plot
p <- ggplot(baltimoreEmissionsByYear, aes(x = factor(year), y = totalEmissions, fill = factor(year)))
p <- p + geom_bar(stat = "identity") + 
    facet_grid(. ~ type) +
    xlab("Year") +
    ylab(expression('Total PM'[2.5]*' emissions (Tonnes)')) +
    ggtitle(expression('Total PM'[2.5]*' emissions from all sources in Baltimore')) +
    theme(legend.position = "none")  ## remove legends

## save the plot
ggsave("plot3.png", plot = p, width = 14, height = 7)


#####################################
## ANSWER THE REQUIRED QUESTION: With the exception of POINT, 
## the remaining three types of sources have reduced the amount of PM2.5 emissions in Baltimore City
