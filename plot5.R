## QUESTION: "How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?"


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
motor <- NEI[(NEI$type=="ON-ROAD") & (NEI$fips == "24510"), ]
motorSummary <- motor %>% 
    group_by(year) %>%
    summarise(sum(Emissions)) %>%
    rename("totalEmissions" = "sum(Emissions)") 

#####################################
## PLOT AND SAVE
## construct plot
p <- ggplot(motorSummary, aes(x = factor(year), y = totalEmissions))
p <- p + geom_bar(stat = "identity", fill = c("red", "green", "blue", "yellow")) + 
    xlab("Year") +
    ylab(expression('Total PM'[2.5]*' emissions (Tonnes)')) +
    ggtitle(expression('Total PM'[2.5]*' emissions from motor vehicle in the USA')) +
    theme(legend.position = "none")  ## remove legends

## save the plot
ggsave("plot5.png", plot = p, width = 7, height = 7)


#####################################
## ANSWER THE REQUIRED QUESTION: As can be seen from the graph, after 10 years, in Baltimore City,
## the amount of PM2.5 emitted from motor vehicle sources went down significantly by more than 3 times 
