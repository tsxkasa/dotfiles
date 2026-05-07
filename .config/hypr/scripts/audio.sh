#!/bin/bash

if [[ "$1" == "up" ]]; then
  qs -c noctalia-shell ipc call volume increase
elif [[ "$1" == "down" ]]; then
  qs -c noctalia-shell ipc call volume decrease
elif [[ "$1" == "mute" ]]; then
  qs -c noctalia-shell ipc call volume muteOutput
fi
