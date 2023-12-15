#!C:\Users\sanjith\Desktop\New folder\profile-rest-api> 

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/sanjithhithub/profile-rest-api.git'

PROJECT_BASE_PATH='C:\Users\sanjith\Desktop\New folder\profile-rest-api>'

echo "Installing dependencies..."
sudo yum update
sudo yum install -y python3-dev python3-venv sqlite python-pip supervisor nginx git

# Create project directory
mkdir -p $PROJECT_BASE_PATH
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

REM Create virtual environment
python -m venv env

REM Activate virtual environment
.\env\Scripts\activate

REM Install Python packages
pip install -r requirements.txt
pip install uwsgi==2.0.18

REM Run migrations and collectstatic
python manage.py migrate
python manage.py collectstatic --noinput

REM Deactivate virtual environment
deactivate

REM Configure supervisor (if applicable, supervisor may not be available on Windows)
REM Configure nginx (if applicable, nginx may not be available on Windows)

echo DONE! :)
