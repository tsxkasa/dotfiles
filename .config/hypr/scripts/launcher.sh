#!/bin/bash

if [[ "$1" == "toggle" ]]; then
  qs -c noctalia-shell ipc call launcher toggle
elif [[ "$1" == "open" ]]; then
  qs -c noctalia-shell ipc call plugin:ipc_changed_launcher open
elif [[ "$1" == "close" ]]; then
  qs -c noctalia-shell ipc call plugin:ipc_changed_launcher close
fi
