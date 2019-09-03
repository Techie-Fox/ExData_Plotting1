library(dplyr)
library(lubridate)
library(readr)

# Read data from file
epc <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, stringsAsFactors = FALSE)

# Parse and trim data
epc <- epc %>%
    mutate(DateTime = dmy_hms(paste(Date, Time))) %>%                         # Parse date and time into POSIXct
    select(DateTime, Sub_metering_1, Sub_metering_2, Sub_metering_3) %>%      # Select only required columns
    filter(DateTime > ymd("2007/02/01"), DateTime < ymd("2007/02/03")) %>%    # Filter to relevant dates
    mutate(Sub_metering_1 = parse_number(Sub_metering_1)) %>%                 # Parse data to numeric
    mutate(Sub_metering_2 = parse_number(Sub_metering_2))
    # Sub_metering_3 imports as number

png(filename = "plot3.png")    # Open PNG graphics device

# Plot graph (only first sub meter)
plot(
    epc$DateTime,
    epc$Sub_metering_1,
    type = "l",
    col = "red",
    xlab = "",
    ylab = "Energy sub metering"
)

points(epc$DateTime, epc$Sub_metering_2, type = "l", col = "green")    # Add second sub meter
points(epc$DateTime, epc$Sub_metering_3, type = "l", col = "blue")     # Add third sub meter

# Add legend
legend(
    "topright",
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    col = c("red", "green", "blue"),
    lty = 1
)

# Close and save graphics device
dev.off()
