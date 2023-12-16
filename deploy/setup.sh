#!/usr/bin/env bash

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/sanjithhithub/profile-rest-api.git'
PROJECT_BASE_PATH='/path/to/your/preferred/location/profiles-rest-api'

echo "Installing dependencies..."
sudo-get update
sudo-get install -y python3-dev python3-venv sqlite python3-pip supervisor nginx git

# Create project directory
mkdir -p $PROJECT_BASE_PATH
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

# Create virtual environment
python3 -m venv $PROJECT_BASE_PATH/env

# Activate the virtual environment
source $PROJECT_BASE_PATH/env/bin/activate

# Install python packages locally within the virtual environment
pip install -r $PROJECT_BASE_PATH/requirements.txt
pip install uwsgi==2.0.18

# Run migrations and collectstatic
cd $PROJECT_BASE_PATH
python manage.py migrate
python manage.py collectstatic --noinput

# Deactivate the virtual environment
deactivate

# Configure supervisor (may still require sudo depending on the system)
sudo cp $PROJECT_BASE_PATH/deploy/supervisor_profiles_api.conf /etc/supervisor/conf.d/profiles_api.conf
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart profiles_api

# Configure nginx (requires sudo)
sudo cp $PROJECT_BASE_PATH/deploy/nginx_profiles_api.conf /etc/nginx/sites-available/profiles_api.conf
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/profiles_api.conf /etc/nginx/sites-enabled/profiles_api.conf
sudo systemctl restart nginx.service

echo "DONE! :)"
