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

# make a vector of SCCs corresponding to short names containing "coal" and "comb"
scc.coal.comb <- source.classification[grepl("coal", source.classification$Short.Name, ignore.case=TRUE) &
grepl("comb", source.classification$Short.Name, ignore.case=TRUE), 'SCC']

#get measurements for coal combustion sources
coal.measurements <- measurements[measurements$SCC %in% scc.coal.comb, ]

summary_data <- ddply(coal.measurements, .(year), summarize, sum=sum(Emissions)/1e3)
title <- "Coal-combustion related emissions"

png('coal_yearly_emissions_usa.png', width=1024, height=768)
qplot(year, sum, data=summary_data, geom=c("point", "line", "text"), binwidth = 2, label=round((sum))) + 
    ylab("PM2.5 emissions, kTons") + 
    xlab("Year") + 
    labs(title=title)
dev.off()