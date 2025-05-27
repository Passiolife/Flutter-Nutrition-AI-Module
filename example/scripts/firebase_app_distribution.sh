#!/bin/bash

# Constants
BUILD_DIR="../build/app/outputs/flutter-apk"  # Default Flutter build output directory
APK_NAME="app-release.apk"                   # Default APK file name

# Variables (Customize these as needed)
FIREBASE_PROJECT_ID="1:344771555334:android:0f6325c6a019c11eff1387"        # Replace with your Firebase project ID
APK_PATH="$BUILD_DIR/$APK_NAME"              # Complete path to the APK file
TESTER_EMAILS=""          # Comma-separated list of tester emails
RELEASE_NOTES=""    # Optional release notes

# Functions
function log() {
  echo -e "\033[1;34m[INFO]\033[0m $1"
}

function error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
  exit 1
}

# 1. Clean the project
log "Cleaning the project..."
flutter clean || error "Failed to clean the project."

# 2. Get dependencies
log "Fetching dependencies..."
flutter pub get || error "Failed to fetch dependencies."

# 3. Build the release APK
log "Building release APK..."
flutter build apk --release || error "Failed to build the release APK."

# 4. Verify APK existence
if [ ! -f "$APK_PATH" ]; then
  error "APK not found at $APK_PATH. Ensure the build process completed successfully."
fi

# 5. Deploy APK to Firebase App Distribution
log "Uploading APK to Firebase App Distribution..."
firebase appdistribution:distribute "$APK_PATH" \
  --app "$FIREBASE_PROJECT_ID" \
  --testers "$TESTER_EMAILS" \
  --release-notes "$RELEASE_NOTES"

# 6. Exit script
if [ $? -eq 0 ]; then
  log "APK successfully uploaded to Firebase App Distribution."
else
  error "Failed to upload APK to Firebase App Distribution."
fi