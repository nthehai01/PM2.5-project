## QUESTION: "Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?"


library(dplyr)


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
data <- NEI %>% 
    group_by(year) %>%
    summarise(sum(Emissions)) %>%
    rename("totalEmissions" = "sum(Emissions)")


#####################################
## PLOT AND SAVE DATA
png("plot1.png", width = 480, height = 480)
plot(data$year, data$totalEmissions, type = 'l', 
     xlab = "Year", ylab = "Total emissions", main = "Total PM2.5 emissions from all sources")
dev.off()


#####################################
## ANSWER THE REQUIRED QUESTION: Yes, the PM2.5 emitted from all sources in the USA 
## has been decreased over the 10-year period starting from 1999
