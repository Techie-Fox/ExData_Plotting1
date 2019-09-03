library(dplyr)
library(lubridate)
library(readr)

# Read data from file
epc <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, stringsAsFactors = FALSE)

# Parse and trim data
epc <- epc %>%
    mutate(DateTime = dmy_hms(paste(Date, Time))) %>%                         # Parse date and time into POSIXct
    select(-Date, -Time, -Global_intensity) %>%                               # Filter out unused columns
    filter(DateTime > ymd("2007/02/01"), DateTime < ymd("2007/02/03")) %>%    # Filter to relevant dates
    mutate(Global_active_power = parse_number(Global_active_power)) %>%       # Parse data to numeric
    mutate(Global_reactive_power = parse_number(Global_reactive_power)) %>%
    mutate(Sub_metering_1 = parse_number(Sub_metering_1)) %>%
    mutate(Sub_metering_2 = parse_number(Sub_metering_2)) %>%
    # Sub_metering_3 imports as number
    mutate(Voltage = parse_number(Voltage))

png(filename = "plot4.png")    # Open PNG graphics device

par(mfrow = c(2,2))    # Set 2x2 graph layout

# Plot Global Active Power
    plot(
        epc$DateTime,
        epc$Global_active_power,
        type = "l",
        xlab = "",
        ylab = "Global Active Power"
    )

# Plot Voltage
    plot(
        epc$DateTime,
        epc$Voltage,
        type = "l",
        xlab = "datetime",
        ylab = "Voltage"
    )

# Plot sub meters
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
            lty = 1,
            bty = "n",
            cex = 0.9
        )

# Plot Global Reactive Power
    plot(
        epc$DateTime,
        epc$Global_reactive_power,
        type = "l",
        xlab = "datetime",
        ylab = "Global_reactive_power"
    )

# Close and save graphics device
dev.off()
