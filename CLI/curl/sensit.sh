#!/bin/sh

token="funlzCcUZUUhq2mDlH914FrDaD82lhR3z9Z79WEjRS0apRO3ek6vUgMEm3czjEGH"

declare -a modes=( "shut down" "temperature mode" "motion mode" "sound mode" "complete" )

function devices() {
    Devices=`curl -X GET -H "Authorization: Bearer $token" https://api.sensit.io/v1/devices 2>/dev/null`
    NbDevices=`echo $Devices | jq ".data|length"`

    i=0
    while [ $i -lt $NbDevices ]
    do
        DevId=`echo $Devices | jq --raw-output ".data[$i].id"`
        DevMode=`echo $Devices | jq --raw-output ".data[$i].mode"`
        NbSensors=`echo $Devices | jq --raw-output ".data[$i].sensors|length"`
        echo "Device ID : $DevId / Nb sensors : $NbSensors / Mode : ${modes[$DevMode]}"
        i=$[$i+1]
    done
}

function configure() {
    if [ $# -ne 4 ]
    then
        echo "Usage: $0 configure <device_id> <sensor_id> period|threshold <value>"
        echo ""
        echo "Exemples: "
        echo "    $0 configure 2289 7979 period 7"
        echo "    $0 configure 2289 7980 threshold 3"
        exit 1
    fi

    DevId=$1
    SensorId=$2
    Param=$3
    Value=$4

    SetMode=`curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d "{ \"sensors\": [{ \"id\": \"$SensorId\", \"config\": { \"$Param\": $Value } }] }" https://api.sensit.io/v1/devices/$DevId`
    #SetMode=`curl -sv --trace - -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d '{ "sensors": [{ "id": "7980", "config": { "threshold": 3 } }] }' https://api.sensit.io/v1/devices/$DevId`
    echo $SetMode 
}

function device() {
    DevId=$1
    Device=`curl -X GET -H "Authorization: Bearer $token" https://api.sensit.io/v1/devices/$DevId 2>/dev/null`
    NbSensors=`echo $Device | jq ".data.sensors|length"`

    i=0
    while [ $i -lt $NbSensors ]
    do
        SensorId=`echo $Device | jq --raw-output ".data.sensors[$i].id"`
        SensorType=`echo $Device | jq --raw-output ".data.sensors[$i].sensor_type"`
        echo "Sensor [$SensorId] : $SensorType"
        i=$[$i+1]
    done
}

function sensor() {
    DevId=$1
    SensorId=$2
    Sensor=`curl -X GET -H "Authorization: Bearer $token" https://api.sensit.io/v1/devices/$DevId/sensors/$SensorId 2>/dev/null`
    echo $Sensor | jq
}

function usage() {
    echo "Usage: $0 <fonction> [<params>]"
    echo ""
    echo "Fonction disonibles :"
    typeset -F | sed 's/declare -f/  -/'
}

# Verification configuration jeton d'acces
if [ -z "$token" ]
then
    echo "Erreur. Editer le script '$0' et renseignez la variable 'token'"
    exit 1
fi

# Verification installation jq
type jq > /dev/null 2>&1
IsJqInstalled=$?
if [ $IsJqInstalled -ne 0 ]
then
    echo "Erreur. Installer l'utilitaire 'jq' : pip install jq "
    echo "ou consulter le site [https://stedolan.github.io/jq/download/]"
    exit 2
fi

eval $@
