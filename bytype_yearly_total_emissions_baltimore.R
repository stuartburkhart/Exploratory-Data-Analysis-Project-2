#setwd("F:/programming/R/coursera_r/exploratory_analysis/exploratory_analysis_project2/")
#getwd()

library(ggplot2)
library(plyr)
#download and unpack data if necessary
data.url = "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("./data")) {dir.create("./data")}
if(!file.exists("./data/data.zip")) {
    download.file(data.url, destfile="./data/data.zip", method="curl")
    unzip("./data/data.zip", exdir="./data")
}

measurements <- readRDS("./data/summarySCC_PM25.rds")
#extract data for Baltimore(fips == "24510")
measurements_baltimore <- measurements[measurements$fips=="24510", ]


summary_data <- ddply(measurements_baltimore, .(type, year), summarize, sum=sum(Emissions))

png('bytype_yearly_total_emissions_baltimore.png', width=1024, height=768)
qplot(year, sum, data=summary_data, color=type, geom=c("point", "smooth", "text"), method="lm", facets=type ~ ., binwidth = 2, label=round((sum))) + 
    ylab("PM2.5 emissions") + 
    xlab("Year")
dev.off()