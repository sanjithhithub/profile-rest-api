#!'\Users\sanjith\Desktop\New folder\profile-rest-api'


set -e

PROJECT_BASE_PATH='\Users\sanjith\Desktop\New folder\profile-rest-api'


git pull
$PROJECT_BASE_PATH/env/bin/python manage.py migrate
$PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput
supervisorctl restart profile_api

echo "DONE! :)"
