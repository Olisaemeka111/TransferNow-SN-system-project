#!/bin/bash

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Upgrade Python to the latest version
echo "Upgrading Python..."
brew upgrade python

# Verify Python version
echo "Python version after upgrade:"
python3 --version


# Upgrade Flask and all dependencies listed in requirements.txt
if [ -f "requirements.txt" ]; then
    echo "Upgrading Flask and all dependencies listed in requirements.txt..."
    pip install --upgrade -r requirements.txt
else
    echo "requirements.txt not found, upgrading Flask only..."
    pip install --upgrade flask
fi

# Optionally, upgrade all installed packages to their latest versions
echo "Upgrading all installed packages..."
pip list --outdated | grep -v '^\-e' | cut -d ' ' -f 1 | xargs -n1 pip install -U

# Optionally, regenerate requirements.txt
echo "Regenerating requirements.txt..."
pip freeze > requirements.txt


# Build Docker image with the updated requirements
echo "Building Docker image..."
docker build -t your_image_name .

echo "Update complete!"