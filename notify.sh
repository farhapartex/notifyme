#!/bin/bash

# Function to get time-based greeting message
GET_GREETING_MESSAGE() {
    # Get the current hour
    HOUR=$(date +"%H")

    # Determine the greeting based on the time of day
    if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
        TITLE="Good Morning!"
        MESSAGE="Hope you have a productive day!"
    elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 17 ]; then
        TITLE="Good Noon!"
        MESSAGE="Take a break and refresh yourself!"
    elif [ "$HOUR" -ge 17 ] && [ "$HOUR" -lt 21 ]; then
        TITLE="Good Evening!"
        MESSAGE="Relax and unwind!"
    else
        TITLE="Good Night!"
        MESSAGE="Time to rest and recharge!"
    fi
}

# Function to display the notification
SHOW_NOTIFICATION() {
    notify-send "$TITLE" "$MESSAGE" --urgency=normal --expire-time=5000
}

# Function to check internet connection
CHECK_INTERNET() {
    # Ping Google to check for internet connectivity
    ping -c 1 google.com > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        INTERNET_STATUS="online"
    else
        INTERNET_STATUS="offline"
    fi
}

# Function to get weather update every 20 minutes
GET_WEATHER_UPDATE() {
    local LOCATION=$1
    if [ "$INTERNET_STATUS" = "online" ]; then
        # If internet is available, fetch weather data using curl
        WEATHER=$(curl -s "https://wttr.in/$LOCATION?format=3")
    else
        # If no internet, set a no-connection message
        WEATHER="No internet connection. Unable to fetch weather data."
    fi
}

# Function to display combined weather and break reminder
SHOW_WEATHER_AND_BREAK_REMINDER() {
    TITLE="Break Reminder & Weather Update"
    MESSAGE="Take a short break and stay hydrated!\n\nCurrent Weather: $WEATHER"
    notify-send "$TITLE" "$MESSAGE" --urgency=normal --expire-time=10000
}

# Main loop to check time and show notifications
while true; do
    # Set your location here
    LOCATION="Dhaka"
    # Get the current minute
    MINUTE=$(date +"%M")

    # Show greeting message at the start of each hour
    if [ "$MINUTE" -eq "00" ]; then
        GET_GREETING_MESSAGE
        SHOW_NOTIFICATION
    fi

    # Check internet connection once every minute
    CHECK_INTERNET

    # Get weather update and show break reminder every 20 minutes
    if (( MINUTE % 20 == 0 )); then
        GET_WEATHER_UPDATE "$LOCATION"
        SHOW_WEATHER_AND_BREAK_REMINDER
    fi

    # Sleep for 60 seconds before checking again
    sleep 60
done
