# Build:
#   docker build -t ksahnine/sensit-velib .
#
# Run:
#   docker run -d -p 8000:8000 -v config.yml:/app/conf/config.yml ksahnine/sensit-velib
#
# DOCKER_VERSION 1.6

# Base image
FROM ksahnine/rpi-python-stack
MAINTAINER Kadda SAHNINE <ksahnine@gmail.com>

# Install Flask/BS4/PyYAML/GeoPy/PushbulletPy
RUN pip install Flask beautifulsoup4 pyyaml geopy pushbullet.py

# Add custom program
COPY tpp /app/tpp
COPY conf /app/conf
COPY app.py /app/app.py

# Define working directory
WORKDIR /app

# Define default command
ENTRYPOINT ["python", "app.py"]
