Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_version = "~> 20200304.0.0"

  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provision "shell", inline: <<-SHELL
    # Disable scheduled tasks
    Disable-ScheduledTask -TaskPath "\\Microsoft\\Windows\\TaskScheduler\\" -TaskName "AitAgent" -Confirm:$false
    Disable-ScheduledTask -TaskPath "\\Microsoft\\Windows\\TaskScheduler\\" -TaskName "SynchronizeTime" -Confirm:$false

    # Update and install necessary packages
    Invoke-Expression "choco install -y python3 zip"

    # Create .bash_aliases and add Python alias
    $bashAliasesPath = Join-Path $env:USERPROFILE ".bash_aliases"
    if (!(Test-Path $bashAliasesPath) -or !(Get-Content $bashAliasesPath | Select-String -Quiet "PYTHON_ALIAS_ADDED")) {
      Add-Content $bashAliasesPath "# PYTHON_ALIAS_ADDED"
      Add-Content $bashAliasesPath "alias python='python3'"
    }
  SHELL
end
