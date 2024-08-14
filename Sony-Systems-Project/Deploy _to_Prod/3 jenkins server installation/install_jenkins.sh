#!/bin/bash

# Update packages
sudo yum update -y

# Add Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins GPG key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Update the package manager
sudo yum update -y

# Install OpenJDK 17
sudo yum install java-17-amazon-corretto -y

# Install Jenkins
sudo yum install jenkins -y

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Wait for Jenkins to start (adjust sleep time as needed)
sleep 60

# Display the initialAdminPassword
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
