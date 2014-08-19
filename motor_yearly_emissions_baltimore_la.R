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
source.classification <- readRDS("./data/Source_Classification_Code.rds")

# make a vector of SCCs corresponding to EI names containing "mobile" and "vehicle"
scc.motor.vehicles <- source.classification[grepl("mobile.*vehicles", source.classification$EI.Sector, ignore.case=TRUE), 'SCC']

#get measurements for coal combustion sources
motor.measurements <- measurements[(measurements$SCC %in% scc.motor.vehicles) & 
                                       measurements$fips %in% c("24510", "06037"), ]

#assign human-readable county names to new variable
motor.measurements$county.name <- ifelse(motor.measurements$fips == "24510",
                                         "Baltimore City", "Los Angeles County")

summary_data <- ddply(motor.measurements, .(county.name, year), summarize, sum=sum(Emissions))
title <- "Motor vehicles related emissions in Baltimore and LA"

png('motor_yearly_emissions_baltimore_la.png', width=1024, height=768)
qplot(year, sum, data=summary_data, geom=c("point", "line", "text"), color=county.name, binwidth = 3, label=round((sum))) + 
    ylab("PM2.5 emissions, tons") + 
    xlab("Year") + 
    labs(title=title)
dev.off()