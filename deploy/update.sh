#!
C:\Users\sanjith\Desktop\New folder\profile-rest-api>

set -e

PROJECT_BASE_PATH='
C:\Users\sanjith\Desktop\New folder\profile-rest-api>'

git pull
$PROJECT_BASE_PATH/env/bin/python manage.py migrate
$PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput
supervisorctl restart profiles_api

echo "DONE! :)"
