zfile = "household_power_consumption.zip"
tfile = "household_power_consumption.txt"
if(!file.exists(zfile)){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",zfile ,mode ='wb')
}
if(!file.exists(tfile)){
    unzip(zfile)
}
#file.remove(zfile)

## as our data is sampled at 1Hz we can make a rough but clever  estimation on where to begin reading lines,
## for data on dates 2007-02-01 and 2007-02-02
HPC =read.csv(tfile, sep =';', nrows = 1) # need first record to get time and date of beginning of monitering 

library(lubridate)
# lines to skip are equal to minuets passed since begining of monitering
minutes_passed = interval( dmy_hms(paste(HPC$Date[1],HPC$Time[1])), dmy_hms("01/02/2007 00:00:00"),) / minutes(1)
# records collected in two days @ 1/min
required_lines = 2 * 24 * 60


# read only the required lines
HPC = read.csv(tfile, sep =';', nrows = required_lines, skip = minutes_passed, col.names = names(HPC))
# remove unnecessery variables
rm(minutes_passed, required_lines, tfile, zfile)

# converting and saving date and time from factors to POSIXct
HPC$datetime = dmy_hms(paste(HPC$Date, HPC$Time))


# start a png device
png(filename = 'plot4.png', height = 480 ,width = 480 )
# ploting to devive (png)
par(mfrow=c(2,2))
with(HPC,{
    plot(datetime, Global_active_power, type = 'l', xlab = '', ylab = "Global Active Power (killowatts)")
    
    plot(datetime, Voltage, type = 'l', ylab = "Voltage")
    
    
    plot(datetime, Sub_metering_1, type = 'l', xlab = '', ylab = "Energy sub metering")
    lines(datetime, Sub_metering_2, type = 'l', col='red')
    lines(datetime, Sub_metering_3, type = 'l', col='blue')
    legend('topright',legend = c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
        lty = 1, col = c('black','red','blue') )
    
    plot(datetime, Global_reactive_power, type = 'l')
})
dev.off()
