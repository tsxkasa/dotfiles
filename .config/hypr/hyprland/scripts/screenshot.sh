wayfreeze --hide-cursor &
wayfreeze_pid=$!

sleep 0.05 # delay depends on how fast is machine, can do 0.2, 0.1, 0.05, 0.01 etc.

geom=$(slurp) && {
  grim -g "$geom" - | wl-copy && notify-send --app-name="grim" "Screenshot saved" "Image copied to clipboard"
}

kill $wayfreeze_pid
