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
#extract data for Baltimore(fips == "24510")
measurements_baltimore <- measurements[measurements$fips=="24510", ]

summary_data <- (tapply(measurements_baltimore$Emissions, 
                        measurements_baltimore$year,
                        sum))/1e3

#draw line plot
png('yearly_total_emissions_baltimore.png', width=640, height=480)
plot(x=names(summary_data), 
     y=summary_data, 
     type="b",
     main="Yearly PM2.5 emissions in Baltimore",
     xlab="Year",
     ylab="Amount of PM2.5 emitted, kTons",
     lwd=2,
     pch=16,
     col=3,
     ylim=c(min(summary_data)-1, max(summary_data)+1))

#label data poins
for(i in 1:length(summary_data)){
text(names(summary_data)[i], summary_data[i] + 0.2, round(summary_data[i],1))
}

dev.off()