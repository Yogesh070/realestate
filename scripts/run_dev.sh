#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
else
  echo "Error: .env file not found!"
  echo "Please copy .env.example to .env and add your API keys"
  exit 1
fi

# Validate API key exists
if [ -z "$GOOGLE_MAPS_API_KEY" ]; then
  echo "Error: GOOGLE_MAPS_API_KEY not set in .env file"
  exit 1
fi

# Run flutter with dart-define
flutter run --dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY "$@"
