#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# run polybar with bar name because we only have one bar right now.
echo "---" | tee -a /tmp/polybar1.log 
polybar 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Bars launched..."
