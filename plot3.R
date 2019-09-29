library(data.table)
library(dplyr)

filename <- "exdata_data_household_power_consumption.zip"

# checking whether thezip file exists
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fpowerdata.zip"
        download.file(fileURL, filename)
}

# Checking whether the unziped file exists
if (!file.exists("household_power_consumption.txt")) { 
        unzip(filename)
}

# Obtaining data  from the dates 2007-02-01 and 2007-02-02
powerdata=fread("household_power_consumption.txt",  sep = ";",nrows = 2880, skip = 66637, na.strings = "?" ,col.names = c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")) 

## Format date to Type Date
powerdata$Date <- as.Date(powerdata$Date, "%d/%m/%Y")

## Adding the column Date_Time and removing date and time columns
powerdata=mutate(powerdata,Date_Time= as.POSIXct(paste(Date, Time)))
powerdata=select(powerdata,-(1:2))
powerdata=powerdata[,c(8,1:7)]

# Plot 3
with(powerdata, {
        plot(Sub_metering_1~Date_Time,type="l", ylab="Global Active Power (kilowatts)", xlab="")
        lines(Sub_metering_2~Date_Time,col="Red")
        lines(Sub_metering_3~Date_Time,col="Blue")
})
legend("topright", col=c("black", "red", "blue"),lwd=c(1,1,1), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png,"plot3.png",width=480, height=480)
dev.off()


