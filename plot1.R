#Plot 1: plots global active power (kilowatts) by frequency on February 1st-2nd, 2007
#library for fread and lubridate
library(data.table)
library(lubridate)

#download data
wd_path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, file.path(wd_path, "C4W1Ass.zip"))
unzip(zipfile = "C4W1Ass.zip")

#read data and keep column names
head_names <- fread("household_power_consumption.txt", nrows = 0)
dat_1st <- fread("grep \\b1/2/2007\\b household_power_consumption.txt", col.names = names(head_names))
dat_2nd <- fread("grep \\b2/2/2007\\b household_power_consumption.txt", col.names = names(head_names))
dat <- rbind(dat_1st, dat_2nd)

#convert date/time from variables to date/time classes
dat$Date <- as.Date(dat$Date, format = "%d/%m/%Y")
dat$DateTime <- paste(dat$Date, dat$Time)
dat$DateTime <- as.POSIXct(dat$DateTime, format = "%Y-%m-%d %H:%M:%S", tz="UTC")

#create histogram and save to file
hist(dat$Global_active_power, main = "Global Active Power", xlab = "Global Active Power 
      (kilowatts)", ylab = "Frequency", col = "red")
dev.copy(png, file = "plot1.png", height = 480, width = 480)
dev.off()

