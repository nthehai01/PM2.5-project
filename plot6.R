## QUESTION: "Compare emissions from motor vehicle sources in Baltimore City 
## with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?"


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
motor <- NEI[(NEI$type == "ON-ROAD"), ]
motor <- motor[(motor$fips == "24510") | (motor$fips == "06037"), ]

motorSummary <- motor %>% 
    group_by(fips, year) %>%
    summarise(sum(Emissions)) %>%
    rename("totalEmissions" = "sum(Emissions)") 


#####################################
## PLOT AND SAVE
## construct plot
p <- ggplot(motorSummary, aes(x = factor(year), y = totalEmissions, fill = factor(year)))
p <- p + geom_bar(stat = "identity") + 
    facet_grid(fips ~ ., scales = "free", 
               labeller = labeller(fips = c("06037" = "Los Angeles County", "24510" = "Baltimore City"))) +
    xlab("Year") +
    ylab(expression('Total PM'[2.5]*' emissions (Tonnes)')) +
    ggtitle(expression('Total PM'[2.5]*' emissions from motor vehicle in the Baltimore City')) +
    theme(legend.position = "none",  text = element_text(size = 5))

## save the plot
ggsave("plot6.png", plot = p, width = 3, height = 3)


#####################################
## ANSWER THE REQUIRED QUESTION: As can be seen from the graph, after 10 years, 
## Los Angeles has seen greater changes over time in motor vehicle emissions.
