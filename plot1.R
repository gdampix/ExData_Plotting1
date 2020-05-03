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
HPC =read.csv(tfile, sep =';', nrows = 1)

library(lubridate)
# lines to skip are equal to minuets passed since begining of monitering
minutes_passed = interval( dmy_hms(paste(HPC$Date[1],HPC$Time[1])), dmy_hms("01/02/2007 00:00:00"),) / minutes(1)
# records collected in two days @ 1/min
required_lines = 2 * 24 * 60

# read only the required lines
HPC = read.csv(tfile, sep =';', nrows = required_lines, skip = minutes_passed, col.names = names(HPC))
# remove unnecessery variables
rm(minutes_passed, required_lines, tfile, zfile)


# start a png device
png(filename = 'plot1.png', height = 480 ,width = 480 )
# ploting to devive (png)
with(HPC,hist(Global_active_power, col = 'red', main = "Global Active Power", xlab = "Global Active Power (killowatts)"))
# saving .png
dev.off()

