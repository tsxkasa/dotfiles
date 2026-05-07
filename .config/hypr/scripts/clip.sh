#!/bin/bash

if [[ "$1" == "toggle" ]]; then
  qs -c noctalia-shell ipc call launcher clipboard
fi
