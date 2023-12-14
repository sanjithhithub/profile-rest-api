# TODO: Set to URL of git repo.
$PROJECT_GIT_URL = 'https://github.com/sanjithhithub/profile-rest-api.git'

$PROJECT_BASE_PATH = 'C:\Users\sanjith\Desktop\New folder\profile-rest-api'

Write-Host "Installing dependencies..."

# Install chocolatey package manager
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install required packages
choco install -y python3 sqlite git

# Create project directory
New-Item -ItemType Directory -Force -Path $PROJECT_BASE_PATH | Out-Null
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

# Create virtual environment
python -m venv $PROJECT_BASE_PATH\env

# Install python packages
$PROJECT_BASE_PATH\env\Scripts\pip install -r $PROJECT_BASE_PATH\requirements.txt
$PROJECT_BASE_PATH\env\Scripts\pip install uwsgi==2.0.18

# Run migrations and collectstatic
cd $PROJECT_BASE_PATH
$PROJECT_BASE_PATH\env\Scripts\python manage.py migrate
$PROJECT_BASE_PATH\env\Scripts\python manage.py collectstatic --noinput

# Configure supervisor (not available on Windows, you might need to find an alternative)
# Configure nginx (not available on Windows, you might need to find an alternative)

Write-Host "DONE! :)"
