#!/C:\Users\sanjith\Desktop\New folder\profile-rest-api

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/sanjithhithub/profile-rest-api.git'

PROJECT_BASE_PATH='C:\Users\sanjith\Desktop\New folder\profile-rest-api'  

echo "Installing dependencies..."
yum update
yum install -y python python-venv sqlite python-pip supervisor nginx git

# Create project directory
mkdir -p $PROJECT_BASE_PATH
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

# Create virtual environment
mkdir -p $PROJECT_BASE_PATH/env
python3 -m venv $PROJECT_BASE_PATH/env

# Activate virtual environment
source $PROJECT_BASE_PATH/env/bin/activate

# Install python packages
pip install -r $PROJECT_BASE_PATH/requirements.txt
pip install uwsgi==2.0.18

# Deactivate virtual environment
deactivate

# Run migrations and collectstatic
cd $PROJECT_BASE_PATH
$PROJECT_BASE_PATH/env/bin/python manage.py migrate
$PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput

# Configure supervisor
cp $PROJECT_BASE_PATH/deploy/supervisor_profiles_api.conf /etc/supervisord.d/profiles_api.conf
supervisord
supervisorctl reread
supervisorctl update
supervisorctl restart profiles_api

# Configure nginx
cp $PROJECT_BASE_PATH/deploy/nginx_profiles_api.conf /etc/nginx/conf.d/profiles_api.conf
systemctl restart nginx

echo "DONE! :)"
