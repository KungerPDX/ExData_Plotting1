
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
#      and renders a histogram of the global active power in KW to PNG file plot1.png.
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

#  No Date/Time processing is necessary for this plot.

#  Plot the histogram per specification,
par(mfrow = c(1,1), mar = c(5, 5.5, 4, 2))
hist( x = hpc$Global_active_power,
      main = "Global Active Power",  
      xlab = "Global Active Power (kilowatts)", 
      ylab = "Frequency", 
      col = "Red"
    ) 

#  Send the plot to the PNG file
dev.copy( png, file = "plot1.png", height = 480, width = 480 ) 
 
#  Release the graphic device for the file
dev.off() 
