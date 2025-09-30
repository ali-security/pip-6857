#!/bin/bash

REPO_SLUG=$(git remote get-url origin | sed -E 's#.*[:/]([^/]+/[^/]+).*#\1#' | sed 's/\.git$//' | sed 's/\//%2F/g')

echo "Fetching builds for: $REPO_SLUG"

# Get the latest build
BUILD_DATA=$(curl -s -H "Travis-API-Version: 3" \
  -H "Authorization: token $TRAVIS_TOKEN" \
  "https://api.travis-ci.com/repo/${REPO_SLUG}/builds?limit=1")

BUILD_ID=$(echo "$BUILD_DATA" | jq -r '.builds[0].id')
BUILD_NUMBER=$(echo "$BUILD_DATA" | jq -r '.builds[0].number')
BUILD_STATE=$(echo "$BUILD_DATA" | jq -r '.builds[0].state')

echo "Build #$BUILD_NUMBER (ID: $BUILD_ID) - State: $BUILD_STATE"
echo ""

# Get all jobs for this build
JOBS=$(curl -s -H "Travis-API-Version: 3" \
  -H "Authorization: token $TRAVIS_TOKEN" \
  "https://api.travis-ci.com/build/${BUILD_ID}/jobs")

# Clear or create the log file
> .travis/travis_logs.txt

# Get number of jobs
JOB_COUNT=$(echo "$JOBS" | jq '.jobs | length')
echo "Found $JOB_COUNT jobs"
echo ""

# Fetch logs for each job
echo "$JOBS" | jq -r '.jobs[] | "\(.id)|\(.state)|\(.config.env // "default")"' | while IFS='|' read -r JOB_ID JOB_STATE JOB_ENV; do
    echo "Fetching logs for Job $JOB_ID ($JOB_STATE) - $JOB_ENV"
    
    echo "========================================" >> .travis/travis_logs.txt
    echo "Job ID: $JOB_ID" >> .travis/travis_logs.txt
    echo "State: $JOB_STATE" >> .travis/travis_logs.txt
    echo "Environment: $JOB_ENV" >> .travis/travis_logs.txt
    echo "========================================" >> .travis/travis_logs.txt
    echo "" >> .travis/travis_logs.txt
    
    curl -s -H "Travis-API-Version: 3" \
      -H "Authorization: token $TRAVIS_TOKEN" \
      "https://api.travis-ci.com/job/${JOB_ID}/log.txt" >> .travis/travis_logs.txt
    
    echo -e "\n\n" >> .travis/travis_logs.txt
done

echo ""
echo "✅ Logs saved to .travis/travis_logs.txt"
