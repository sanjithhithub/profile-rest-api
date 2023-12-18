#!/usr/bin/env bash

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/sanjithhithub/profile-rest-api.git'
PROJECT_BASE_PATH='/path/to/your/preferred/location/profiles-rest-api'

echo "Installing dependencies..."
sudo yum update
sudo yum install -y python3-dev python3-venv sqlite python3-pip supervisor nginx git

# The rest of your script remains unchanged
