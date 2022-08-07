#Plot 4: creates four plots in a panel from data on February 1st-2nd, 2007
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

#convert date/time from variables to date/time classes, creates weekday column
dat$Date <- as.Date(dat$Date, format = "%d/%m/%Y")
dat$DateTime <- paste(dat$Date, dat$Time)
dat$DateTime <- as.POSIXct(dat$DateTime, format = "%Y-%m-%d %H:%M:%S", tz="UTC")
dat$weekday <- wday(dat$Date, label = TRUE)

#create plots
par(mfrow = c(2,2))

#1st graph (top left) is "plot2"
plot (dat$Global_active_power~dat$DateTime, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")

#2nd graph (top right) is datetime vs voltage
plot (dat$Voltage~dat$DateTime, type = "l", ylab = "Voltage", xlab = "datetime")

#3rd graph (bottom left) is "plot3"
plot (dat$Sub_metering_1~dat$DateTime, type = "l", ylab = "Energy sub metering", xlab = "")
lines(dat$Sub_metering_2~dat$DateTime, type = "l", col="red")
lines(dat$Sub_metering_3~dat$DateTime, type = "l", col="blue")
legend(c("topright"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, lwd=1, col = c("black", "red", "blue"))

#4th graph (bottom right) is datetime vs Global_reactive_power
plot (dat$Global_reactive_power~dat$DateTime, type = "l", ylab = "Global_reactive_power", xlab = "datetime")

dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()