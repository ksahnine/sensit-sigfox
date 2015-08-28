# Build:
#   docker build -t ksahnine/rpi-sensit-velib .
#
# Run:
#   docker run -d -p 5000:5000 -v ~/config.yml:/app/conf/config.yml ksahnine/rpi-sensit-velib
#
# DOCKER_VERSION 1.6

# Base image
FROM ksahnine/rpi-python-stack
MAINTAINER Kadda SAHNINE <ksahnine@gmail.com>

# Install Flask/BS4/PyYAML/GeoPy
RUN pip install Flask beautifulsoup4 pyyaml geopy

# Install PushbulletPy
RUN mkdir /var/pb && cd /var/pb && \
    git config --global http.sslVerify false && \
    git clone https://github.com/randomchars/pushbullet.py.git && \
    cd /var/pb/pushbullet.py && python ./setup.py install 

# Clean
RUN cd && rm -rf /var/pb

# Add custom program
COPY tpp /app/tpp
COPY conf /app/conf
COPY app.py /app/app.py

# Define working directory
WORKDIR /app

# Define default command
ENTRYPOINT ["python", "app.py"]
