# Introduction ------------------------------------------------------------
# This R script reproduces the plot4.png image from the Coursera assignment
# "ExData_Plotting1". 

# 1. Download and unzip file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destfile <- "epc.zip"

if(!file.exists(destfile)){
    download.file(url, destfile);
    unzip("epc.zip")
}

# NOTE: To avoid reading the whole file instead of the wanted dates, I checked
# in Unix command line where the dates start and end. Specifically, I used the following commands:
#       grep -n  "^2/2/2007\|^1/2/2007" household_power_consumption.txt | head
#       grep -n  "^2/2/2007\|^1/2/2007" household_power_consumption.txt | tail
# This provided me with the lines (counting header as 1st line) 66638 to 69517.

#2. Read the data into power variable, only the necessary dates (see NOTE).
power <- read.table("household_power_consumption.txt", 
                    sep = ";", 
                    dec = ".",
                    header = TRUE,
                    stringsAsFactors = FALSE,
                    colClasses = c("character", "character", rep("numeric",7)),
                    na.strings = "?")[66637:69516,]

#3. Convert Date and Time column to their respective formats.
power$datetime <- paste(power$Date, power$Time)
power$datetime <- strptime(power$datetime, "%d/%m/%Y %T")
power$Date <- as.Date(power$Date, "%d/%m/%y")

png(filename="plot4.png", width=504, height=504) #Initialize graphics device

par(mfrow=c(2,2))

    #Topleft plot
    plot(power$datetime, power$Global_active_power, 
         type="l",
         ylab="Global Active Power (kilowatts)",
         xlab="")
    
    #Topright plot
    plot(power$datetime, power$Voltage, 
         type="l",
         ylab="Voltage",
         xlab="datetime")
    
    #Bottomleft plot
    plot(power$datetime,power$Sub_metering_1, 
         type="n",
         xlab="",
         ylab="Energy submetering")
    lines(power$datetime,power$Sub_metering_1, col="black")
    lines(power$datetime,power$Sub_metering_2, col="red")
    lines(power$datetime,power$Sub_metering_3, col="blue")
    legend("topright", 
           legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           col=c("black", "red", "blue"),lty=1, bty="n")
    
    plot(power$datetime, power$Global_reactive_power, 
         type="l",
         ylab="Global_reactive_power",
         xlab="datetime")
    
    dev.off() #Close graphics device
