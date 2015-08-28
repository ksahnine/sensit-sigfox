# Velib callback

Consulter l'article [*Pratique du réseau M2M SIGFOX avec Sens'it et Docker*](http://ksahnine.github.io/iot/m2m/sigfox/docker/2015/08/26/sensit-sigfox.html).

## Docker

[![dockeri.co](http://dockeri.co/image/ksahnine/ratp-rest-api)](https://registry.hub.docker.com/u/ksahnine/rpi-sensit-velib/)

### Build
```
docker build -t ksahnine/rpi-sensit-velib .
```

### Run
```
docker run -d -p 5000:5000 -v ~/config.yml:/app/conf/config.yml ksahnine/rpi-sensit-velib
```
