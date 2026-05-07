#!/bin/bash

if [[ "$1" == "toggle" ]]; then
  playerctl play-pause

elif [[ "$1" == "stop" ]]; then
  playerctl stop

elif [[ "$1" == "prev" ]]; then
  playerctl previous

elif [[ "$1" == "next" ]]; then
  playerctl next

elif [[ "$1" == "play" ]]; then
  playerctl play-pause

elif [[ "$1" == "pause" ]]; then
  playerctl play-pause

fi
