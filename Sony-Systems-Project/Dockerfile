# Use an official Python runtime as a parent image
FROM python:3.7-slim

# Set environment varibles

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Set work directory
WORKDIR /app

# Install any needed packages specified in requirements.txt
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run the application when the container launches
CMD ["flask", "run"]