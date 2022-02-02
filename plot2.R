## QUESTION: "Have total emissions from PM2.5 decreased 
## in the Baltimore City, Maryland (fips = 24510) from 1999 to 2008?"


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
baltimore <- NEI[NEI$fips == "24510", ] %>% 
    group_by(year) %>%
    summarise(sum(Emissions)) %>%
    rename("totalEmissions" = "sum(Emissions)")


#####################################
## PLOT AND SAVE DATA
png("plot2.png", width = 700, height = 700, res = 120)
barplot(height =  baltimore$totalEmissions/1000, names.arg = baltimore$year, 
        xlab = "Years", ylab = expression('Total PM'[2.5]*' emissions (Kilotonnes)'),
        main = expression('Total PM'[2.5]*' emissions from all sources in Baltimore'),
        col = c("red", "green", "blue", "yellow"))
dev.off()


#####################################
## ANSWER THE REQUIRED QUESTION: Yes, the PM2.5 emitted from all sources in the Baltimore City 
## has been decreased over the 10-year period starting from 1999
