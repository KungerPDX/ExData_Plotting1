
################################################################################################
#
#  Exploratory Data Analysis
#  Week 1 Project
#  Johns Hopkins University via Coursera
#  Roger D. Peng, instructor
# 
#  Kevin Unger
#  4 Nov 2017
#  
#  Purpose:  Conditionally downloads the UCI household power data for 1 Feb 2007 and 2 Feb 2007
#      and renders two previous plots plus two new plots to PNG file 
#      plot4.png.  2x2 trellis.
#  
#      Previous plots:  Global active power line chart and sub-metering line chart.
#      New plots:  Voltage by datetime and Global reactive power by datetime line charts.
#
#  Changes to previous plots (per project requirements):
#      The global active power line chart has had the units removed from the y-axis legend.
#      The sub-metering line chart has had the box removed from around the top right legend.
#
#  For further information:  See README.md for a full description of the project requirements, 
#      files, and raw file variables.
#
################################################################################################


# Set working directory as desired
# setwd("C:\\Users\\kunger\\Documents\\R\\ExploratoryDataAnalysisWeek1\\ExploratoryDataAnalysisWeek1Project")

#  If the text file containing the raw data does not exist, see if the zip file does; download it if not.  Then
#  extract the text file.

if (!file.exists("household_power_consumption.txt")) {
        if (!file.exists("household_power_consumption.zip") ) {
                fileurl <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
                download.file(url = fileurl, destfile = "household_power_consumption.zip")        
        }
        unzip(zipfile = "household_power_consumption.zip")
}

#  Read the data.  Data for the date range 1 Feb 2007 through 2 Feb 2007 starts on row 66638 and ends on row
#  69517 (including the single header row), which is a run of 2880 rows.  Convert ?s to NAs directly on import.
hpc <- read.csv( file = "household_power_consumption.txt", 
                 header = FALSE, 
                 sep = ";",
                 na.strings = "?",
                 skip = 66637,
                 nrows = (69517 - 66638 + 1),  # Equals 2880
                 stringsAsFactors = FALSE,
                 col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", 
                               "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
               ) 

#  Add a new Datetime variable to the data frame that has the full date and time in one spot and in POSIX format.
hpc$Datetime <- strptime(paste(hpc$Date, hpc$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

#  Spool the plots to the trellis row-wise.
par(mfrow = c(2,2))

#  The basic global active power line chart, upper left
plot(x = hpc$Datetime, y = hpc$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power") 

#  A new panel, voltage by datetime, upper right
plot(x = hpc$Datetime, y = hpc$Voltage, type = "l", xlab = "datetime", ylab="Voltage") 

#  The submetering, lower left
plot(x = hpc$Datetime, y = hpc$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "") 
lines(x = hpc$Datetime, y = hpc$Sub_metering_2, type = "l", col = "red") 
lines(x = hpc$Datetime, y = hpc$Sub_metering_3, type = "l", col = "blue") 
legend( x = "topright", 
        bty = "n",            # Removal of the legend box 
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
        lty = 1, 
        col = c("black", "red", "blue"), 
        text.width = 97500    # Needed to prevent legend truncation in the PNG file
      )    

#  And one more new panel, global reactive power by datetime, lower right
plot(hpc$Datetime, hpc$Global_reactive_power, type="l", xlab="dateime", ylab="Global_reactive_power")

#  Send the plot to the PNG file
dev.copy( png, file = "plot4.png", height = 480, width = 480 ) 

#  Release the graphic device for the file
dev.off() 
