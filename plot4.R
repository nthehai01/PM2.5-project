## QUESTION: "Across the United States, 
## how have emissions from coal combustion-related sources changed from 1999–2008?"


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
temp <- grepl("Coal", SCC$EI.Sector)  ## check if the name of source contains "Coal"
coalDigitStrings <- SCC[temp, 1]  ## extract the SCC digit strings that from coal combustion-related sources

coal <- NEI[NEI$SCC %in% coalDigitStrings, ]  ## extract the records in NEI where the PM2.5 was emitted by coal
coalSummary <- coal %>% 
    group_by(year) %>%
    summarise(sum(Emissions)) %>%
    rename("totalEmissions" = "sum(Emissions)") 


#####################################
## PLOT AND SAVE
## construct plot
p <- ggplot(coalSummary, aes(x = factor(year), y = totalEmissions/1000))
p <- p + geom_bar(stat = "identity", fill = c("red", "green", "blue", "yellow")) + 
    xlab("Year") +
    ylab(expression('Total PM'[2.5]*' emissions (Kilotonnes)')) +
    ggtitle(expression('Total PM'[2.5]*' emissions from coal in the USA')) +
    theme(legend.position = "none", text = element_text(size = 8)) 

## save the plot
ggsave("plot4.png", plot = p, width = 3, height = 3)


#####################################
## ANSWER THE REQUIRED QUESTION: As can be seen from the graph, the amount of PM2.5 emitted 
## from coal combustion-related sources went down by almost 2 times after 10 years in the USA
