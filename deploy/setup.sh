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
# Configure nginx
cp "$PROJECT_BASE_PATH/deploy/nginx_profiles_api.conf" "/etc/nginx/sites-available/profiles_api.conf"
rm -f "/etc/nginx/sites-enabled/default" || true

# Create a symbolic link
ln -sf "/etc/nginx/sites-available/profiles_api.conf" "/etc/nginx/sites-enabled/profiles_api.conf"

# Restart Nginx
if systemctl restart nginx.service; then
    echo "Nginx restarted successfully."
else
    echo "Error: Unable to restart Nginx."
    exit 1
fi

echo "DONE! :)"