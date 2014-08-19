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
                                       measurements$fips=="24510", ]

summary_data <- ddply(motor.measurements, .(year), summarize, sum=sum(Emissions))
title <- "Motor vehicles related emissions in Baltimore"

png('motor_yearly_emissions_baltimore.png', width=1024, height=768)
qplot(year, sum, data=summary_data, geom=c("point", "line", "text"), binwidth = 3, label=round((sum))) + 
    ylab("PM2.5 emissions, tons") + 
    xlab("Year") + 
    labs(title=title)
dev.off()