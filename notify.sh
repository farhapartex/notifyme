#!/bin/bash

get_greeting_message() {
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
show_notification() {
    notify-send "$TITLE" "$MESSAGE" --urgency=normal --expire-time=5000
}

# Function to display periodic reminder every 20 minutes
show_periodic_reminder() {
    TITLE="Reminder"
    MESSAGE="Take a short break and stay hydrated!"
    notify-send "$TITLE" "$MESSAGE" --urgency=normal --expire-time=5000
}


while true; do
    # Get the current minute
    MINUTE=$(date +"%M")

    # Show greeting message at the start of each hour
    if [ "$MINUTE" -eq "00" ]; then
        get_greeting_message
        show_notification
    fi

    # Show reminder every 20 minutes
    if (( MINUTE % 20 == 0 )); then
        show_periodic_reminder
    fi

    # Sleep for 60 seconds before checking again
    sleep 60
done
