#!/bin/bash

# doil is a tool that creates and manages multiple docker container
# with ILIAS and comes with several tools to help manage everything.
# It is able to download ILIAS and other ILIAS related software
# like cate.
#
# Copyright (C) 2020 - 2021 Laura Herzog (laura.herzog@concepts-and-training.de)
# Permission to copy and modify is granted under the AGPL license
#
# Contribute: https://github.com/conceptsandtraining/ilias-tool-doil
#
#                    .-.
#                   / /
#                  / |
#    |\     ._ ,-""  `.
#    | |,,_/  7        ;
#  `;=     ,=(     ,  /
#   |`q  q  ` |    \_,|
#  .=; <> _ ; /  ,/'/ |
# ';|\,j_ \;=\ ,/   `-'
#     `--'_|\  )
#    ,' | /  ;'
#   (,,/ (,,/      Thanks to Concepts and Training for supporting doil

function doil_get_hash() {
  if [ -z "$1" ]
  then
    echo "No name of instance given, aborting"
    exit
  fi

  DCPROC=$(docker ps | grep $1 -w)
  DCPROCHASH=${DCPROC:0:12}
  echo $DCPROCHASH
}

doil_get_data() {
  if [ -z "$1" ]
  then
    echo "No hash given, aborting"
    exit
  fi

  if [ -z "$2" ]
  then
    echo "No datatype given, aborting"
    exit
  fi

  case $2 in
    "ip")
      echo $(docker inspect --format "{{ .NetworkSettings.Networks.doil_proxy.IPAddress }}" $1)
      ;;
    "hostname")
      echo $(docker inspect -f '{{.Config.Hostname}}' $1)
      ;;
    "domainname")
      echo $(docker inspect -f '{{.Config.Domainname}}' $1)
      ;;
  esac
}

doil_send_log() {
  NOW=$(date +'%d.%m.%Y %I:%M:%S')
  echo "[$NOW] $1"
}