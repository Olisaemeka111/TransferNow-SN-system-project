# SN-systems-project
SN systems Remote project
Site Reliability Engineer Exercise

Objective

This project involves developing a simple networked service that allows users to upload a file via a web browser and receive the MD5 hash of its contents in response. The service is implemented in a lightweight, easily deployable manner, using Docker on a Linux or Windows OS.

Technology Stack

Programming Language: Python
Web Framework: Flask
Hashing: hashlib (Python Standard Library)
Containerization: Docker
Operating System: Linux or Windows (Docker-compatible)
Libraries:
- Flask: A lightweight WSGI web application framework
- Werkzeug: A WSGI utility library
- hashlib: A Python standard library for MD5 hash generation.


Directory Structure

├── Dockerfile
├── app.py
├── requirements.txt
└── README.md.



Implementation Steps:
Step 1: Set up Flask Application:
Create a basic Flask web server that handles file uploads via an HTML form.
On receiving a file, the server will calculate its MD5 hash using hashlib.md5() and return the hash to the user.
Step 2: Dockerize the Application:
Write a Dockerfile to containerize the Flask application.
The Dockerfile will use a Python base image, copy the application code into the container, install dependencies, and start the Flask server.
Step 3: Documentation:
Create a README.md file that explains how to build, run, and interact with the service.
Write additional technical documentation detailing the code, deployment, and maintenance instructions.
Process Methodology:
Development:
Use an iterative approach, starting with a basic Flask server and gradually adding functionality.
Testing:
Test the service locally using Docker to ensure it functions as expected.
Deployment:
Provide instructions on deploying the Docker container on any Linux or Windows system.
Documentation:
Include clear and concise instructions for setup, usage, and maintenance in the README.md.