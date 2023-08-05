#!/bin/bash

AWS_PROFILE="default";
THRESHOLD_MAX_DAYS=90;
CURRENT_DATE=$(date +%Y-%m-%d);
REPORT_DIR=$(pwd)/reports;
REPORT_FILE="report";
REPORT="$REPORT_DIR/$REPORT_FILE".txt;
GMAIL_DOMAIN_EMAIL="@gmail.com";
