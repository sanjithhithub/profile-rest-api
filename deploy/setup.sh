#!/C:\Users\sanjith\Desktop\New folder\profile-rest-api> 

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/sanjithhithub/profile-rest-api.git'

PROJECT_BASE_PATH='C:\Users\sanjith\Desktop\New folder\profile-rest-api> '

echo "Installing dependencies..."
sudo-yum update
sudo-yum install -y python3-dev python3-venv sqlite python-pip supervisor nginx git

# Create project directory
sudo mkdir -p $PROJECT_BASE_PATH
sudo git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

# Create virtual environment
sudo mkdir -p $PROJECT_BASE_PATH/env
sudo python3 -m venv $PROJECT_BASE_PATH/env

# Install python packages
sudo $PROJECT_BASE_PATH/env/bin/pip install -r $PROJECT_BASE_PATH/requirements.txt
sudo $PROJECT_BASE_PATH/env/bin/pip install uwsgi==2.0.18

# Run migrations and collectstatic
cd $PROJECT_BASE_PATH
sudo $PROJECT_BASE_PATH/env/bin/python manage.py migrate
sudo $PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput

# Configure supervisor
sudo cp $PROJECT_BASE_PATH/deploy/supervisor_profiles_api.conf /etc/supervisor/conf.d/profiles_api.conf
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart profiles_api

# Configure nginx
sudo cp $PROJECT_BASE_PATH/deploy/nginx_profiles_api.conf /etc/nginx/sites-available/profiles_api.conf
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/profiles_api.conf /etc/nginx/sites-enabled/profiles_api.conf
sudo systemctl restart nginx.service

echo "DONE! :)"
