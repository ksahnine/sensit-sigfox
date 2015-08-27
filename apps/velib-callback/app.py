#!/usr/bin/python
# -*- coding: utf-8 -*-
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

__author__  = "Kadda SAHNINE"
__contact__ = "ksahnine@gmail.com"
__license__ = 'GPL v3'

from flask import Flask, request
from pushbullet import Listener, PushBullet, Device
import json
import logging
import yaml
import sys
import os

sys.path.append( "%s/%s" % (os.getcwd(), 'tpp'))
from libs.velib import Velib

# Mode debug
debug=True

logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s')

configFile = "conf/config.yml"
logger = logging.getLogger()

# Fichier de conf
if os.path.isfile(configFile):
    with open(configFile, 'r') as f:
        conf = yaml.load(f)
else:
    logger.error("ERROR. Le fichier de configuration %s n'existe pas !", configFile)
    sys.exit(1)

# Configuration du niv de trace
logger.setLevel(conf['logging_level'])

app = Flask(__name__)
app.config.update(
    DEBUG=debug,
    PROPAGATE_EXCEPTIONS=debug
)

def notify_velib():
    """
    Envoi un CR de disponibilite des Velibs a proximite 
    """
    location = conf["location"]
    rayon = int(conf["rayon"])

    velib = Velib()
    message = ""
    for station, nbVelib in velib.dispo(location,rayon).items():
        message += "Station %s : %d velos dispos\n" % (station, nbVelib)

    logger.debug("*Debut* notification pushbullet")
    pb = PushBullet(conf["pushbullet"]["api"])
    phone = pb.devices[0]
    phone.push_note("Dispos Velibs", message)
    logger.debug("*Fin* notification pushbullet")

@app.route('/sensit/button/pressed', methods=['GET'])
def button():
    """
    Callback invoquee par Sens'it lors d'un double clic
    Configurer l'URL de callback sur https://www.sensit.io/notifications
    """
    pressed_at = request.args.get('date')
    print pressed_at
    logger.debug("[Sensit/bouton] Date notification : %s", pressed_at)
    notify_velib()
    return 'OK\n' 

if __name__ == '__main__':
    app.run(host='0.0.0.0')
