# C:\Users\sanjith\Desktop\New folder\profile-rest-api>
$PROJECT_GIT_URL = 'https://github.com/sanjithhithub/profile-rest-api.git'

# Set the desired project path
$PROJECT_BASE_PATH = 'C:\Users\sanjith\Desktop\New folder\profile-rest-api>'

Write-Host "Installing dependencies..."

# Update and install dependencies
sudo yum update -y
sudo yum install -y python3 python3-devel python3-venv sqlite python3-pip supervisor nginx git

# Create project directory
New-Item -Path $PROJECT_BASE_PATH -ItemType Directory -Force
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

# Create virtual environment
New-Item -Path "$PROJECT_BASE_PATH\env" -ItemType Directory -Force
python3 -m venv "$PROJECT_BASE_PATH\env"

# Activate virtual environment
Activate-VirtualEnvironment $PROJECT_BASE_PATH\env\Scripts\Activate.ps1

# Install python packages
pip install -r "$PROJECT_BASE_PATH\requirements.txt"
pip install uwsgi==2.0.18

# Deactivate virtual environment
Deactivate

# Run migrations and collectstatic
Set-Location $PROJECT_BASE_PATH
& "$PROJECT_BASE_PATH\env\Scripts\python" manage.py migrate
& "$PROJECT_BASE_PATH\env\Scripts\python" manage.py collectstatic --noinput

# Configure supervisor
Copy-Item "$PROJECT_BASE_PATH\deploy\supervisor_profiles_api.conf" 'C:\ProgramData\supervisord\conf.d\profiles_api.conf'
Start-Service supervisor

# Configure nginx
Copy-Item "$PROJECT_BASE_PATH\deploy\nginx_profiles_api.conf" 'C:\nginx\conf.d\profiles_api.conf'
Restart-Service nginx

Write-Host "DONE! :)"
