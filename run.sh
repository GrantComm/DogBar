#!/bin/bash

# This script is used to run the application

# Start the node.js server in the background.
(cd dog_server; node server.js) &

# Start the flutter application.
flutter run -d chrome