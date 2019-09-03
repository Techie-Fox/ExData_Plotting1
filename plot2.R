library(dplyr)
library(lubridate)
library(readr)

# Read data from file
epc <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, stringsAsFactors = FALSE)

# Parse and trim data
epc <- epc %>%
    mutate(DateTime = dmy_hms(paste(Date, Time))) %>%                         # Parse date and time into POSIXct
    select(DateTime, Global_active_power) %>%                                 # Select only required columns
    filter(DateTime > ymd("2007/02/01"), DateTime < ymd("2007/02/03")) %>%    # Filter to relevant dates
    mutate(Global_active_power = parse_number(Global_active_power))           # Parse data to numeric

png(filename = "plot2.png")    # Open PNG graphics device

# Plot graph
plot(
    epc$DateTime,
    epc$Global_active_power,
    type = "l",
    xlab = "",
    ylab = "Global Active Power (kilowatts)"
)

# Close and save graphics device
dev.off()
