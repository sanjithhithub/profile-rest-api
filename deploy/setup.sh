#!/usr/bin/env bash

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/sanjithhithub/profile-rest-api.git'

PROJECT_BASE_PATH='/usr/local/apps/profile-rest-api'

echo "Installing dependencies..."
apt-get update
apt-get install -y python3-dev python3-venv sqlite python-pip supervisor nginx git

# Create project directory
mkdir -p "$PROJECT_BASE_PATH"
git clone "$PROJECT_GIT_URL" "$PROJECT_BASE_PATH"

# Create virtual environment
python3 -m venv "$PROJECT_BASE_PATH/env"

# Activate virtual environment
source "$PROJECT_BASE_PATH/env/bin/activate"

# Install python packages
pip install -r "$PROJECT_BASE_PATH/requirements.txt"
pip install uwsgi==2.0.21

# Run migrations and collectstatic
cd "$PROJECT_BASE_PATH"
python manage.py migrate
python manage.py collectstatic --noinput

echo "DONE! :)"

# Configure supervisor
cp $PROJECT_BASE_PATH/deploy/supervisor_profiles_api.conf /etc/supervisor/conf.d/profiles_api.conf
supervisorctl reread
supervisorctl update
supervisorctl restart profiles_api

echo "DONE! :)"

# Configure nginx
#!/bin/bash

PROJECT_BASE_PATH="/path/to/your/project"  # Change this to your actual project base path

nginx_config_file="$PROJECT_BASE_PATH/deploy/nginx_profiles_api.conf"
nginx_syslink_path="/etc/nginx/sites-enabled/profiles_api.conf"
default_nginx_config_file="/etc/nginx/sites-enabled/default"

# Copy the nginx config file to sites-available
cp "$nginx_config_file" /etc/nginx/sites-available/profiles_api.conf

# Remove the default nginx config if it exists
if [ -f "$default_nginx_config_file" ]; then
    rm "$default_nginx_config_file"
fi

# Remove the default symlink in sites-enabled
if [ -f "$nginx_syslink_path" ]; then
    rm "$nginx_syslink_path"
fi

# Create a new symlink in sites-enabled
ln -s /etc/nginx/sites-available/profiles_api.conf "$nginx_syslink_path"

# Restart nginx
systemctl restart nginx.service

echo "DONE! :)"
