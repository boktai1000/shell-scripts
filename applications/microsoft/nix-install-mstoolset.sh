#!/usr/bin/env bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/microsoft/nix-install-mstoolset.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/microsoft/nix-install-mstoolset.sh | sudo bash

# Check for Red Hat-based distro
if [ -f /etc/redhat-release ]; then
    
    # Setup Azure CLI Repo
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
    
    # Install Packages
    sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
    sudo yum update
    sudo yum -y install azure-cli dotnet-sdk-2.2 nuget powershell
    
fi

# Check for Debian-based distro
if [ -f /etc/debian_version ]; then
    
    # Install Azure CLI
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    
    # Install .NET Core - Ubuntu 18.04
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install dotnet-sdk-2.2 apt-transport-https powershell

    # Install NuGet
    sudo apt-get install nuget -y
    
fi
