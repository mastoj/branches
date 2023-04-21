#!/bin/bash

# This script has the following inputs:
# 1. a comma separated list of JIRA issues to update
# 2. a value for environment
# 3. a value for version
# It also uses the following environment variables:
# JIRA_USER_AND_PASSWORD
# JIRA_URL
#
# Using those inputs, it will update the JIRA issues 
# and add the value for environment to the custom field customfield_10234,
# and add the value for version to the custom field customfield_10237.
#
# Example usage: 
# JIRA_USER_AND_PASSWORD="user:password" JIRA_URL="https://jira.example.com" ./update-jira.sh "ABC-123,ABC-456" "Production" "1.0.0"

# The JIRA issues to update
JIRA_ISSUES=$1
# The value for environment
ENVIRONMENT=$2
# The value for version
VERSION=$3

# The JIRA custom field for environment
ENVIRONMENT_FIELD="customfield_10234"
# The JIRA custom field for version
VERSION_FIELD="customfield_10237"

# The JIRA API URL
JIRA_API_URL="$JIRA_URL/rest/api/2/issue"

# The JIRA API payload
JIRA_PAYLOAD="{\"update\": {\"$ENVIRONMENT_FIELD\":  [{ \"add\": {\"value\": \"$ENVIRONMENT\"} }], \"$VERSION_FIELD\": [{\"add\": \"$VERSION\"}]}}"

# Update the JIRA issues
for JIRA_ISSUE in $(echo $JIRA_ISSUES | sed "s/,/ /g")
do
    echo "Updating JIRA issue $JIRA_ISSUE"
    echo "Payload: $JIRA_PAYLOAD"
    echo "API URL: $JIRA_API_URL/$JIRA_ISSUE"
    echo "User and password: $JIRA_USER_AND_PASSWORD"
    curl --silent --location --request PUT "$JIRA_API_URL/$JIRA_ISSUE" \
        --user $JIRA_USER_AND_PASSWORD \
        --header "Content-Type: application/json" \
        --data-raw "$JIRA_PAYLOAD" 
done
