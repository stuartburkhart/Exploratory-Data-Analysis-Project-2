#setwd("F:/programming/R/coursera_r/exploratory_analysis/exploratory_analysis_project2/")
#getwd()

#download and unpack data if necessary
data.url = "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("./data")) {dir.create("./data")}
if(!file.exists("./data/data.zip")) {
    download.file(data.url, destfile="./data/data.zip", method="curl")
    unzip("./data/data.zip", exdir="./data")
}

measurements <- readRDS("./data/summarySCC_PM25.rds")

summary_data <- (tapply(measurements$Emissions, measurements$year, sum))/1e6

#draw line plot
png('yearly_total_emissions.png', width=640, height=480)
plot(x=names(summary_data), 
     y=summary_data, 
     type="b",
     main="Yearly PM2.5 emissions",
     xlab="Year",
     ylab="Amount of PM2.5 emitted, MTons",
     lwd=2,
     pch=16,
     col=3,
     ylim=c(min(summary_data)-0.5, max(summary_data)+0.4))

#label data poins
for(i in 1:length(summary_data)){
text(names(summary_data)[i], summary_data[i] + 0.3, round(summary_data[i], 1))
}

dev.off()