#!/bin/bash

# Update and install system packages
apt-get update && apt-get upgrade -y && \
apt-get install -y --no-install-recommends gcc g++ make python3 python3-dev python3-pip python3-venv python3-wheel espeak-ng libsndfile1-dev && \
rm -rf /var/lib/apt/lists/*

# Install Python packages
pip3 install llvmlite --ignore-installed
pip3 install torch torchaudio --extra-index-url https://download.pytorch.org/whl/cu118
pip3 install flask gunicorn

# Clone the repository
git clone https://github.com/NaveenAare/voice_cloneing.git ~/voice_cloning

# Create a virtual environment
python3 -m venv ~/voice_cloning/venv
source ~/voice_cloning/venv/bin/activate

# Install Python dependencies
pip install --upgrade pip setuptools wheel
pip install -r ~/voice_cloning/requirements.txt

# Create log files
touch ~/voice_cloning/access.log ~/voice_cloning/error.log

# Run the Flask app using Gunicorn
nohup ~/voice_cloning/venv/bin/gunicorn --bind 0.0.0.0:5000 ~/voice_cloning/app:app --access-logfile ~/voice_cloning/access.log --error-logfile ~/voice_cloning/error.log &
